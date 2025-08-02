# CineMatch: A SQL-Based Movie Recommendation Engine

CineMatch is a dynamic, user-driven movie discovery platform that allows users to explore, rate, and contribute to a growing database of films. It features a modern, responsive interface and a powerful admin panel for managing content. This project is designed to showcase a full-stack web application built with Python, Flask, and PostgreSQL, demonstrating a strong understanding of database management, web development, and user-centric design.

## Why CineMatch?

In a world saturated with content, finding the right movie can be a challenge. CineMatch solves this by providing a community-driven platform where users can:

*   **Discover new films:** Search and filter through an extensive collection of movies.
*   **Get reliable ratings:** See how other users have rated films to make informed decisions.
*   **Contribute to the community:** Submit new movies to the database and help it grow.

This project is not just a movie database; it's a demonstration of how to build a scalable, maintainable, and user-friendly web application from the ground up.

## Features

*   **Modern, Responsive UI:** Built with Tailwind CSS for a clean, professional look on any device.
*   **Dynamic Search:** Instantly find movies by title, genre, or tags.
*   **User Submissions:** A simple form allows users to add new movies to the database.
*   **Admin Approval System:** A dedicated admin panel allows for the approval or rejection of user-submitted movies, ensuring data quality.
*   **Statistical Dashboard:** The admin panel provides at-a-glance statistics on the movie database.
*   **RESTful API:** The backend is built with Flask, providing a clean and organized API for managing data.

## Technical Stack

*   **Backend:** Python, Flask
*   **Database:** PostgreSQL
*   **Frontend:** HTML, Tailwind CSS, JavaScript
*   **Database Connector:** psycopg2

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Python 3.x
*   PostgreSQL

### Installation

1.  **Clone the repo**
    ```sh
    git clone https://github.com/your_username/CineMatch.git
    cd CineMatch
    ```
2.  **Install Python packages**
    ```sh
    pip install -r requirements.txt
    ```
3.  **Set up the database**
    *   Create a new PostgreSQL database named `cinematch`.
    *   Update the database connection settings in `app.py` if necessary.
    *   Run the `schema.sql` file to create the necessary tables.
        ```sh
        psql -U your_username -d cinematch -f schema.sql
        ```

### Running the Application

1.  **Start the Flask server**
    ```sh
    python app.py
    ```
2.  **Access the application**
    *   Main site: `http://127.0.0.1:5000`
    *   Admin panel: `http://127.0.0.1:5000/admin`

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.