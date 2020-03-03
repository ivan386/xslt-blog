var parser = new DOMParser();

function test_text(){
	var checkbox = document.querySelector(".текст input.тест")
	var test = document.querySelector(".текст span.тест")
	var text = document.querySelector(".текст textarea")
	if (checkbox.checked){
		var rez = parser.parseFromString(`<текст>${text.value}</текст>`, "application/xhtml+xml");
		test.innerHTML = rez.firstElementChild.innerHTML;
		
		test.style.display = "initial";
		text.style.display = "none";
	}else{
		test.style.display = "none";
		text.style.display = "initial";
		text.focus();
	}
}

function save_xml(){
	var title = document.querySelector(".заголовок input").value
	var text = document.querySelector(".текст textarea").value
	var link_save = document.querySelector(".текст a[onclick='save_xml()']")
	link_save.setAttribute("download", title.replace(/<[^>]*>/gm, "") + ".xml")
	link_save.setAttribute(
		"href"
		,   'data: text/xml,' 
		  + encodeURI(
`<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet href="xslt/запись.xslt" type="text/xsl" ?>
<запись>
<заголовок>${title}</заголовок>
<текст>${text}</текст>
</запись>`
		)
	)
	
	var link_update = document.querySelector(".текст a.update_journal")
	link_update.setAttribute("href", '')
	
	fetch("журнал.xml")
	.then((rez)=>rez.text())
	.then(function(text){
		text = text.replace("<журнал>", `<журнал>\n\t<запись>${title}</запись>`)
		link_update.setAttribute("href", 'data: text/xml,' + encodeURI(text))
	})
}