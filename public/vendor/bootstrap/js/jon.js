
var input = document.querySelector('input');

var span = document.querySelector('#boxL');

input.addEventListener('input', function()
{
    span.textContent = input.value;
});

var range_el = document.querySelector('input[type=range]'), 
    style_el = document.createElement('style'), 
    range_style = getComputedStyle(range_el), 
    pad = range_style.paddingTop.split('px')[0], 
    w = range_style.width.split('px')[0], 
    fill_max_w = w - 2*pad, 
    messages = [
      'Not even started', 
      'Barely started', 
      'Almost half way', 
      'More than half done', 
      'Almost there', 
      'Done', 
      'Half way there'
    ];

document.body.appendChild(style_el);

range_el.addEventListener('input', function() {
  var perc = this.value, dec = perc/100, 
      fill_w = Math.round(dec*fill_max_w), msg = messages[0];
  
  for(var i = 0; i < 4; i++) {
    if(perc > i*25 && i <= (i + 1)*25) {
      msg = messages[(perc == 100)?5:((perc == 50)?6:(i + 1))];
    }
  }
    
  style_el.textContent = 
    '.js input[type=range]::-webkit-slider-runnable-track:before,' + 
    '.js input[type=range] /deep/ #track:before{width:' + fill_w + 'px}' + 
    '.js input[type=range]::-webkit-slider-thumb:before,' + 
    '.js input[type=range] /deep/ #thumb:before{content:"' + perc + '%"}' + 
    '.js input[type=range]::-webkit-slider-thumb:after,' + 
    '.js input[type=range] /deep/ #thumb:after{content:"' + msg + '"}';
}, false);