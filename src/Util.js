function getPos(element) {
    let x = 0, y = 0;
    if(!!element) {
        do {
            x += element.offsetLeft - element.scrollLeft;
            y += element.offsetTop - element.scrollTop;
        } while (element = element.offsetParent);
    }
    return { 'x': x, 'y': y };
}

function getShortMonth(index) {
    let monthNames =["Gen","Feb","Mar","Apr",
                      "Mag","Giu","Lug","Ago",
                      "Set", "Ott","Nov","Dic"];
    return monthNames[index];
}

export {
    getPos,
    getShortMonth
}
