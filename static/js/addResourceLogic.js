// Listen for form submission
document.getElementById('resourceForm').addEventListener('submit', function(event) {
    event.preventDefault(); // Prevent default form submission

    // Get form data
    const name = document.getElementById('name').value;
    const description = document.getElementById('description').value;
    const category = document.getElementById('category').value;
    const sharedWith = document.getElementById('shared-with').value;
    const session = document.getElementById('session').value;
    const resourceLink = document.getElementById('resource-link').value;

    // Prepare data
    const data = {
        name: name,
        description: description,
        category: category,
        shared_with: sharedWith,
        session: session,
        'resource-link': resourceLink
    };

    // Send data to backend
    fetch('/addResource', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams(data)
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            alert(data.message);
            window.location.href = '/dashboard'; // Redirect to dashboard
        } else {
            alert('Failed to add resource.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('An error occurred while adding the resource.');
    });
});
