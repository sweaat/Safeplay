const apiKey = '2a1d014aff3047c89633948844735bfb'; // Remplacez par votre clé API
const apiUrl = `https://api.rawg.io/api/games?key=${apiKey}`;

async function fetchNews() {
    try {
        const response = await fetch(apiUrl);
        if (!response.ok) {
            throw new Error(`Erreur HTTP! Statut: ${response.status}`);
        }
        const data = await response.json();
        displayNews(data.results);
    } catch (error) {
        console.error('Erreur lors de la récupération des actualités:', error);
    }
}

function getRandomGames(games, count) {
    const shuffled = games.sort(() => 0.5 - Math.random());
    return shuffled.slice(0, count);
}

function displayNews(newsItems) {
    const randomGames = getRandomGames(newsItems, 6); // Sélectionnez 6 jeux aléatoirement
    randomGames.forEach((newsItem, index) => {
        const newsElement = document.getElementById(`news${index + 1}`);
        if (newsItem) {
            newsElement.innerHTML = `
                <h2>${newsItem.name}</h2>
                <img src="${newsItem.background_image}" alt="${newsItem.name}" style="width: 100%; border-radius: 10px;">
                <p>Sortie: ${newsItem.released}</p>
                <p>Note Metacritic: ${newsItem.metacritic ? newsItem.metacritic : 'N/A'}</p>
                <p>Genres: ${newsItem.genres.map(genre => genre.name).join(', ')}</p>
                <a href="https://rawg.io/games/${newsItem.slug}" target="_blank">Lire plus</a>
            `;
        } else {
            newsElement.innerHTML = '<p>Aucune donnée disponible</p>';
        }
    });
}

fetchNews();

function toggleNewConversation() {
    var newConversation = document.querySelector('.new-conversation');
    if (newConversation.style.display === 'none' || newConversation.style.display === '') {
        newConversation.style.display = 'block';
    } else {
        newConversation.style.display = 'none';
    }
}
