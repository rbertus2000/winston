const openInWinstonBanner = `<div id="winstonBanner"> <img src="https://winston.cafe/james-webb.jpg" class="winstonBannerBg"><div class="logoHeyWrapper"> <img src="https://winston.cafe/side-winston-tinyfied.png"><div>Hey!</div></div><a href="winstonapp:/${url}" class="openInWinstonButton">Open in Winston!</a><button id="closeBannerButton" style="">X</button></div>`
document.body.insertAdjacentHTML("beforeend", openInWinstonBanner)
setTimeout(() => {
  document.getElementById("closeBannerButton").addEventListener("click", function () {
    removeElementByQuery("#winstonBanner")
  })
}, 100)
