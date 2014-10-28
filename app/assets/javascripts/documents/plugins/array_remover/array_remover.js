// Array Remove - By John Resig (MIT Licensed)
// http://stackoverflow.com/questions/500606/javascript-array-delete-elements
Array.prototype.remove = function(from, to) {
    var rest = this.slice((to || from) + 1 || this.length);
    this.length = from < 0 ? this.length + from : from;
    return this.push.apply(this, rest);
};
