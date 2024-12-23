// Get all sidebar menu items
const sidebarItems = document.querySelectorAll('.menu li');
const selectedSidebarItem = document.getElementById('selectedSidebarItem');

// Get the Add Resource button
const addResourceButton = document.getElementById('addResourceBtn');

// Add click event to sidebar items
sidebarItems.forEach(item => {
    item.addEventListener('click', () => {
        // Update the selected item in the main content area
        selectedSidebarItem.textContent = item.textContent;

        // Highlight the selected item in the sidebar
        sidebarItems.forEach(el => el.classList.remove('active'));
        item.classList.add('active');

        // Redirect if "Add Resource" in sidebar
        if (item.textContent.trim() === "Add Resource") {
            window.location.href = "/addResource";
        }
    });
});

// Add click event to the Add Resource button
if (addResourceButton) {
    addResourceButton.addEventListener('click', () => {
        console.log("Add Resource button clicked"); // Debugging
        window.location.href = "/addResource";
    });
} else {
    console.error("Add Resource button not found!");
}
