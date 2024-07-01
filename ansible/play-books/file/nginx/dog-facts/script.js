document.addEventListener('DOMContentLoaded', function() {
    const factContainer = document.getElementById('dog-fact');
    const imageContainer = document.getElementById('dog-image');
    const newFactButton = document.getElementById('new-fact');

    async function getDogFact() {
        try {
            const response = await fetch('https://dog-api.kinduff.com/api/facts');
            const data = await response.json();
            factContainer.textContent = data.facts[0];
        } catch (error) {
            factContainer.textContent = 'Oops! Something went wrong.';
        }
    }

    async function getDogImage() {
        try {
            const response = await fetch('https://dog.ceo/api/breeds/image/random');
            const data = await response.json();
            imageContainer.src = data.message;
        } catch (error) {
            imageContainer.src = '';
            factContainer.textContent = 'Oops! Something went wrong.';
        }
    }

    async function getDogFactAndImage() {
        await getDogFact();
        await getDogImage();
    }

    newFactButton.addEventListener('click', getDogFactAndImage);

    // Fetch the first dog fact and image on page load
    getDogFactAndImage();
});
