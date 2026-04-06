/* eslint-disable no-undef */

// Firebase Cloud Messaging service worker.
// This file MUST be available at: /firebase-messaging-sw.js
// so Firebase Messaging can register the default service worker.

importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts(
  'https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js',
);

firebase.initializeApp({
  apiKey: 'AIzaSyCNrYfa-Fr_iFFtiNKP8Fit27ZuO75JeIM',
  authDomain: 'attendx24-1f890.firebaseapp.com',
  projectId: 'attendx24-1f890',
  storageBucket: 'attendx24-1f890.firebasestorage.app',
  messagingSenderId: '649534744462',
  appId: '1:649534744462:web:0e2e684141a8383bbda6df',
  measurementId: 'G-XN0V8MQLW3',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const title = payload?.notification?.title || 'Notification';
  const options = {
    body: payload?.notification?.body,
    icon: '/icons/Icon-192.png',
  };

  self.registration.showNotification(title, options);
});
