function setupFloorBoxInteractions() {
  const floorBoxes = document.querySelectorAll('.floor-box');

  floorBoxes.forEach(box => {
    box.addEventListener('click', () => {
      floorBoxes.forEach(b => b.classList.remove('active'));
      box.classList.add('active');
    });
  });
}

setupFloorBoxInteractions();

window.addEventListener('DOMContentLoaded', setupFloorBoxInteractions);
