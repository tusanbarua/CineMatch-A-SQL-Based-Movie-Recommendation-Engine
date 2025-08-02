
document.addEventListener('DOMContentLoaded', () => {
    const adminPanelButton = document.getElementById('adminPanelButton');
    const adminPanel = document.getElementById('adminPanel');
    const addMovieForm = document.getElementById('addMovieForm');

    // Toggle Admin Panel
    if (adminPanelButton) {
        adminPanelButton.addEventListener('click', () => {
            if (adminPanel.style.display === 'none' || adminPanel.style.display === '') {
                adminPanel.style.display = 'block';
            } else {
                adminPanel.style.display = 'none';
            }
        });
    }

    // Handle Movie Submission
    if (addMovieForm) {
        addMovieForm.addEventListener('submit', async (e) => {
            e.preventDefault();

            const formData = new FormData(addMovieForm);
            const data = Object.fromEntries(formData.entries());

            try {
                const response = await fetch('/add_movie', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(data)
                });

                const result = await response.json();

                if (result.success) {
                    alert('Movie submitted for approval!');
                    addMovieForm.reset();
                } else {
                    alert(`Error: ${result.message}`);
                }
            } catch (error) {
                console.error('Error submitting movie:', error);
                alert('An error occurred while submitting the movie.');
            }
        });
    }

    
});
