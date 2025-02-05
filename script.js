const modal = document.querySelector('.modal');
const overlay = document.querySelector('.overlay');
const btnCloseModal = document.querySelector('.close-modal');

const openModal = function () {
  modal.classList.remove('hidden');
  overlay.classList.remove('hidden');
};

const closeModal = function () {
  modal.classList.add('hidden');
  overlay.classList.add('hidden');
};

openModal();

btnCloseModal.addEventListener('click', closeModal);

document.addEventListener('keydown', function (e) {

  if (e.key === 'Escape' && !modal.classList.contains('hidden')) {
    closeModal();
  }
});

function hideshow(a){
  const list= document.getElementById("list" + a);
    if(list.style.display == "block")
      list.style.display="none";
    else {
      list.style.display="block";
    }
} 

var ImageIndex = [0,0,0,0,0,0];

function increment(b){
  ImageIndex[b]++;
  if (ImageIndex[b] == 3)
    {
      ImageIndex[b] = 0;
    }
    transitioning(b,ImageIndex[b]);

}

function decrement(b)
{
  ImageIndex[b]--;
  if (ImageIndex[b] == -1)
    {
      ImageIndex[b] = 2;
    }
  transitioning(b,ImageIndex[b]);
}

function transitioning(b,a)
{
    var Images = [["hardware/1024.png", "hardware/4090-2.jpg", "hardware/4090-3.jpg"],
    ["hardware/4080.jpg", "hardware/4080-2.jpg", "hardware/4080.3.jpg"],
    ["hardware/7900-1.jpg", "hardware/7900-2.jpg", "hardware/7900-3.jpg"],
    ["hardware/xt.jpg", "hardware/xt-2.jpg", "hardware/xt-3.jpg"],
    ["hardware/3050.jpg", "hardware/3050-1.jpg", "hardware/3050-2.jpg"],
    ["hardware/6600.jpg", "hardware/6600-1.jpg", "hardware/6600-2.jpg"]];
    var tempimage = document.getElementById("imagescrolling"+b);
    tempimage.setAttribute("src",Images[b][a]);

}

