var styleTag = document.createElement("style");
styleTag.textContent = '.article_container .content-list{display: none !important;} .foot_nav{display: none !important;} .botscroll_info{display: none !important;} .copyright{display: none !important;} :root .article_ad{display: none !important;} .more_client{display: none !important;} .sub_box{display: none !important;} .a_adtemp{display: none !important;} .topbar{display: none !important;} .article_list .article_head{padding: 0 0 0 0 !important;}';
document.documentElement.appendChild(styleTag);

//显示单张图片
function showSinglePic(index) {
    window.webkit.messageHandlers.showSinglePic.postMessage(index);
}

//播放视频
function playVideo(index) {
    window.webkit.messageHandlers.playVideo.postMessage(index);
}

//播放视频
function goWeibo(index) {
    window.webkit.messageHandlers.goWeibo.postMessage(index);
}