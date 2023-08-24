var selectedCourse = null;
var successPopup = document.getElementById("successpopup");

function showPopup(courseElement, courseTitle, courseTime, lecturerName, participants, roomNumber) {
  if (selectedCourse) {
    selectedCourse.classList.remove("active");
  }

  var popupContainer = document.getElementById("popupContainer");
  popupContainer.classList.add("show");

  document.getElementById("courseTitle").textContent = courseTitle;
  document.getElementById("courseTime").textContent = courseTime;
  document.getElementById("lecturerName").textContent = lecturerName;
  document.getElementById("participants").textContent = participants;
  document.getElementById("roomNumber").textContent = roomNumber;

  courseElement.classList.add("active");

  selectedCourse = courseElement;
}

function hidePopup() {
  var popupContainer = document.getElementById("popupContainer");
  popupContainer.classList.remove("show");

  if (selectedCourse) {
    selectedCourse.classList.remove("active");
    selectedCourse = null;
  }
  hideForm();
}

document.addEventListener("click", function(event) {
  if (!event.target.closest(".popup-container") && !event.target.closest(".course")) {
    hidePopup();
  }
});


function showForm() {
  document.getElementById("infoText").style.display = "none";
  document.getElementById("buttonGroup").style.display = "none";
  document.getElementById("form-group").style.display = "block";
      const dropdown = document.getElementById('hari');
      dropdown.addEventListener('change', function () {
        const selectedHari = dropdown.value;
        console.log('Hari yang dipilih:', selectedHari);
        dropdown.style.color = "#000";
      });
  document.getElementById("session-form").style.display = "block";
      const dropdownSession = document.getElementById('session');
      dropdownSession.addEventListener('change', function () {
        const selectedSession = dropdownSession.value;
        console.log('Durasi Mata Kuliah yang dipilih:', selectedSession);
        dropdownSession.style.color = "#000";
      });
  document.getElementById("myContainer").style.display = "block";
  document.getElementById("reasonfield").style.display = "block";
  document.getElementById("submitButton").style.display = "block";

}


function hideForm() {
  document.getElementById("infoText").style.display = "block";
  document.getElementById("buttonGroup").style.display = "block";
  document.getElementById("form-group").style.display = "none";
    const dropdown = document.getElementById('hari');
    dropdown.selectedIndex = 0; 
    dropdown.style.color = "#ccc"; 
  document.getElementById("session-form").style.display = "none";
    const dropdownSession = document.getElementById('session');
    dropdownSession.selectedIndex = 0;
    dropdownSession.style.color = "#ccc";
  document.getElementById("myContainer").style.display = "none";
  document.getElementById("myInput").value = "";
  document.getElementById("reasonfield").style.display = "none";
  document.getElementById("submitButton").style.display = "none";
  hideAllErrorMessages();
}

function changeTextColor(input) {
  if (input.value) {
    input.style.color = "#000000"; 
  } else {
    input.style.color = "#cccccc"; 
  }
}

function filterFunction() {
  var input, filter, dropdown, options, i;
  input = document.getElementById("myInput");
  filter = input.value.toLowerCase().trim();
  dropdown = document.getElementById("myDropdown");
  options = dropdown.getElementsByTagName("a");

  var noMatch = true; 

  for (i = 0; i < options.length; i++) {
    var optionValue = options[i].innerHTML.toLowerCase().trim();
    if (optionValue.startsWith(filter)) {
      options[i].style.display = "";
      noMatch = false; 
    } else {
      options[i].style.display = "none";
    }
  }

  if (noMatch && filter !== "") {
    var notAvailableOption = document.createElement("a");
    notAvailableOption.textContent = "Kelas tidak tersedia";
    notAvailableOption.style.display = "block";
    notAvailableOption.style.color = "grey";
    dropdown.appendChild(notAvailableOption);
  } else {
    var notAvailableOptions = dropdown.querySelectorAll("a");
    notAvailableOptions.forEach(function(option) {
      if (option.textContent === "Kelas tidak tersedia") {
        dropdown.removeChild(option);
      }
    });
  }

  dropdown.classList.add("show");
  
  if (filter === "") {
    var notAvailableOption = dropdown.querySelector("a");
    if (notAvailableOption && notAvailableOption.textContent === "Kelas tidak tersedia") {
      dropdown.removeChild(notAvailableOption);
    }
    for (i = 0; i < options.length; i++) {
      options[i].style.display = "block";
    }
  }
}


function toggleDropdown() {
  var dropdown = document.getElementById("myDropdown");
  dropdown.classList.toggle("show");
}

function selectOption(option) {
  var input = document.getElementById("myInput");
  input.value = option;
  toggleDropdown();
}

window.onclick = function(event) {
  if (!event.target.matches('#myInput')) {
    var dropdown = document.getElementById("myDropdown");
    if (dropdown.classList.contains('show')) {
      dropdown.classList.remove('show');
    }
  }
}

function countCharacters() {
  var textarea = document.getElementById("alasan");
  var characterCount = document.getElementById("characterCount");
  var count = textarea.value.length;
  characterCount.innerHTML = count + "/100";
}

function collectData() {
  var hariValue = document.getElementById("hari").value;
  var sessionValue = document.getElementById("session").value;
  var myInputValue = document.getElementById("myInput").value;
  var alasanValue = document.getElementById("alasan").value;

  if (hariValue === "" || sessionValue === "" || myInputValue === "" || alasanValue === "") {
    showOrHideErrorMessage("hari", hariValue === "");
    showOrHideErrorMessage("session", sessionValue === "");
    showOrHideErrorMessage("myInput", myInputValue === "");
    showOrHideErrorMessage("alasan", alasanValue === "");

    return;
  }

  myInputValue = myInputValue.toLowerCase();
  var dropdownOptions = document.querySelectorAll("#myDropdown a");
  var dropdownValues = [];
  for (var i = 0; i < dropdownOptions.length; i++) {
    dropdownValues.push(dropdownOptions[i].innerText.toLowerCase());
  }

  if (!dropdownValues.includes(myInputValue)) {
    showOrHideErrorMessage("myInput", true);
    alert("Pilih kelas yang tersedia!");
    return;
  } else {
    showOrHideErrorMessage("myInput", false);
  }

  console.log("Hari: " + hariValue);
  console.log("Durasi Mata Kuliah: " + sessionValue);
  console.log("Kelas: " + myInputValue);
  console.log("Alasan: " + alasanValue);

  document.getElementById("hari").value = "";
  document.getElementById("session").value = "";
  document.getElementById("myInput").value = "";
  var dropdown = document.getElementById("myDropdown");
  dropdown.classList.toggle("show");
  document.getElementById("alasan").value = "";
  characterCount.innerHTML = "0/100";

  hideAllErrorMessages();

  var successPopup = document.getElementById("successpopup");
  successPopup.style.display = "block";

  setTimeout(function () {
    closeSuccessPopup();
  }, 10000);

  hidePopup();
}

function showOrHideErrorMessage(fieldId, shouldShow) {
  var errorMessage = document.getElementById(`${fieldId}-error`);
  errorMessage.style.display = shouldShow ? "flex" : "none";
}

function hideAllErrorMessages() {
  var errorMessages = document.querySelectorAll(".error-message");
  for (var i = 0; i < errorMessages.length; i++) {
    errorMessages[i].style.display = "none";
  }
}


function closeSuccessPopup() {
  var successPopup = document.getElementById("successpopup");
  successPopup.style.animation = "slideOutToRight 0.5s ease-in-out forwards";
  setTimeout(function () {
    successPopup.style.display = "none";
    successPopup.style.animation = ""; 
  }, 500); 
}
