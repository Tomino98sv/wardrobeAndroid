var modal = document.getElementById('id01');
  window.onclick = function(event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  }
var firebaseConfig = {
  apiKey: "AIzaSyAJO1gWHi-EDYHCenr5SOssR2TRNnERAyI",
    authDomain: "https://console.firebase.google.com/u/0/project/wardrobe-2324a/authentication/users",
      databaseURL: "https://console.firebase.google.com/u/0/project/wardrobe-2324a/database/firestore/data~2Fitems~2F-LZa0Mv7OLDhGtNQLsjB",
        projectId: "project-id",
          storageBucket: "https://console.firebase.google.com/u/0/project/wardrobe-2324a/storage/wardrobe-2324a.appspot.com/files",
            messagingSenderId: "sender-id",
  };
firebase.initializeApp(firebaseConfig);
var ref = firebase.database().ref();
  ref.on("value", function(snapshot){
    output.innerHTML = JSON.stringify(snapshot.val(), null, 2);
});
