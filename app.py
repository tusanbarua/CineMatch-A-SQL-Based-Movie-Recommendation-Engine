import psycopg2
from flask import Flask, render_template, request, jsonify, redirect, url_for

# --- Database Connection ---
def get_db_connection():
    """Establishes a connection to the PostgreSQL database."""
    try:
        conn = psycopg2.connect(
            dbname="cinematch",
            user="postgres",
            password="root",
            host="localhost",
            port="5432"
        )
        return conn
    except psycopg2.OperationalError as e:
        print(f"Error: Could not connect to the database. Please check your connection settings.")
        print(e)
        return None

# --- Flask App ---
app = Flask(__name__)

# --- Routes ---

@app.route('/')
def index():
    """Main page: Displays movies and submission form."""
    conn = get_db_connection()
    if not conn:
        return "<h1>Error: Database connection failed.</h1>"

    cur = conn.cursor()
    search_query = request.args.get('search', '')

    # If a search query is provided, filter the results
    if search_query:
        sql_query = """
            SELECT DISTINCT m.title, g.genre_name, m.release_year, COALESCE(AVG(r.rating), 0) as avg_rating
            FROM Movies m
            JOIN Genres g ON m.genre_id = g.genre_id
            LEFT JOIN Ratings r ON m.movie_id = r.movie_id
            WHERE m.title ILIKE %s OR g.genre_name ILIKE %s
            GROUP BY m.title, g.genre_name, m.release_year
            ORDER BY avg_rating DESC;
        """
        search_term = f"%{search_query}%"
        cur.execute(sql_query, (search_term, search_term))
    else:
        # Otherwise, get all movies
        sql_query = """
            SELECT m.title, g.genre_name, m.release_year, COALESCE(AVG(r.rating), 0) as avg_rating
            FROM Movies m
            JOIN Genres g ON m.genre_id = g.genre_id
            LEFT JOIN Ratings r ON m.movie_id = r.movie_id
            GROUP BY m.title, g.genre_name, m.release_year
            ORDER BY m.title;
        """
        cur.execute(sql_query)
    
    movies = cur.fetchall()

    # Fetch genres for the submission form
    cur.execute("SELECT genre_id, genre_name FROM Genres ORDER BY genre_name")
    genres = cur.fetchall()

    cur.close()
    conn.close()
    
    return render_template('index.html', movies=movies, genres=genres, search_query=search_query)

@app.route('/admin')
def admin():
    """Admin panel: Displays stats and pending submissions."""
    conn = get_db_connection()
    if not conn:
        return "<h1>Error: Database connection failed.</h1>"

    cur = conn.cursor()

    # Fetch stats for the dashboard
    cur.execute("SELECT COUNT(*) FROM Movies")
    total_movies = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM submissions WHERE approved = FALSE")
    pending_submissions = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM submissions WHERE approved = TRUE")
    approved_submissions = cur.fetchone()[0]

    stats = {
        'total_movies': total_movies,
        'pending_submissions': pending_submissions,
        'approved_submissions': approved_submissions
    }

    # Fetch all pending submissions
    cur.execute("""
        SELECT s.submission_id, s.title, g.genre_name, s.release_year 
        FROM submissions s
        JOIN Genres g ON s.genre_id = g.genre_id
        WHERE s.approved = FALSE
    """)
    submissions = [dict(zip([column[0] for column in cur.description], row)) for row in cur.fetchall()]

    cur.close()
    conn.close()

    return render_template('admin.html', stats=stats, submissions=submissions)

@app.route('/admin/approve/<int:submission_id>', methods=['POST'])
def approve_submission(submission_id):
    """Approves a movie submission and adds it to the Movies table."""
    conn = get_db_connection()
    if not conn:
        return "<h1>Error: Database connection failed.</h1>"

    cur = conn.cursor()
    try:
        # Get the submission details
        cur.execute("SELECT title, genre_id, release_year FROM submissions WHERE submission_id = %s", (submission_id,))
        submission = cur.fetchone()

        if submission:
            # Insert the movie into the Movies table
            cur.execute(
                "INSERT INTO Movies (title, genre_id, release_year) VALUES (%s, %s, %s)",
                (submission[0], submission[1], submission[2])
            )
            # Mark the submission as approved
            cur.execute("UPDATE submissions SET approved = TRUE WHERE submission_id = %s", (submission_id,))
            conn.commit()
    finally:
        cur.close()
        conn.close()
    
    return redirect(url_for('admin'))

@app.route('/admin/reject/<int:submission_id>', methods=['POST'])
def reject_submission(submission_id):
    """Rejects a movie submission by deleting it."""
    conn = get_db_connection()
    if not conn:
        return "<h1>Error: Database connection failed.</h1>"

    cur = conn.cursor()
    try:
        cur.execute("DELETE FROM submissions WHERE submission_id = %s", (submission_id,))
        conn.commit()
    finally:
        cur.close()
        conn.close()

    return redirect(url_for('admin'))

@app.route('/add_movie', methods=['POST'])
def add_movie():
    """Endpoint for users to submit new movies."""
    data = request.get_json()
    title = data.get('title')
    genre_id = data.get('genre_id')
    release_year = data.get('release_year')

    if not all([title, genre_id, release_year]):
        return jsonify({'success': False, 'message': 'Missing required fields.'}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({'success': False, 'message': 'Database connection failed.'}), 500

    cur = conn.cursor()
    try:
        # Insert the new movie as a pending submission
        cur.execute(
            "INSERT INTO submissions (title, genre_id, release_year, approved) VALUES (%s, %s, %s, FALSE)",
            (title, genre_id, release_year)
        )
        conn.commit()
        return jsonify({'success': True})
    except Exception as e:
        conn.rollback()
        return jsonify({'success': False, 'message': str(e)}), 500
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    app.run(debug=True)