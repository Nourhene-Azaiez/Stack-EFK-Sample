

window.addEventListener('DOMContentLoaded', event => {

    // Toggle the side navigation
    const sidebarToggle = document.body.querySelector('#sidebarToggle');
    if (sidebarToggle) {
        // Uncomment Below to persist sidebar toggle between refreshes
        if (localStorage.getItem('sb|sidebar-toggle') === 'true') {
            document.body.classList.toggle('sb-sidenav-toggled');
        }
        sidebarToggle.addEventListener('click', event => {
            event.preventDefault();
            document.body.classList.toggle('sb-sidenav-toggled');
            localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
        });
    }
    
});

function showIframe(contentType) {
    document.getElementById('descriptionSection').style.display = 'none';
    var iframe = document.getElementById('iframeContent');
    switch (contentType) {
        case 'Service_Log':
            iframe.src = 'http://localhost:5601/app/dashboards#/view/f8899390-5b03-11ef-8654-c3a6af238bb6?embed=true&show-time-filter=true&show-filter-bar=true';
            setActiveLink('link2');
            break;
        case 'serviceHealth':
            iframe.src = 'http://localhost:5601/app/dashboards#/view/dc93bdc0-54ad-11ef-a60c-03c88cfd0d88?embed=true&show-time-filter=true&show-filter-bar=true';
            setActiveLink('link3');
            break;
        case 'serviceHistory':
            iframe.src = 'http://localhost:5601/app/dashboards#/view/a0510e70-54c2-11ef-98aa-5b3efbe1ccb4?embed=true&show-time-filter=true&show-filter-bar=true';
            setActiveLink('link4');
            break;
        case 'User':
            iframe.src = 'http://localhost:5601/security/account';
            setActiveLink('link5');
            break;
        default:
            iframe.src = 'about:blank';
    }
}

function setActiveLink(activeLinkId) {
    const links = document.querySelectorAll('.nav-link');
    
    links.forEach(link => {
        link.classList.remove('active');
    });
    
    const activeLink = document.getElementById(activeLinkId);
    if (activeLink) {
        activeLink.classList.add('active');
    }
}

function showDescription() {
    document.getElementById('descriptionSection').style.display = 'block';
    document.getElementById('iframeContent').src = 'about:blank';
}
