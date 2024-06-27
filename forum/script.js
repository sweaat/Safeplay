// script.js

document.getElementById('forum-search-input').addEventListener('input', function () {
    const searchQuery = this.value.toLowerCase();
    const forumItems = document.querySelectorAll('.forum-item');

    forumItems.forEach(item => {
        const title = item.querySelector('h2 a').textContent.toLowerCase();
        if (title.includes(searchQuery)) {
            item.style.display = 'block';
        } else {
            item.style.display = 'none';
        }
    });
});
