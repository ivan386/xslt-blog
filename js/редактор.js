var parser = new DOMParser();

function get_xml(title, text)
{
	return `<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet href="xslt/запись.xslt" type="text/xsl" ?>
<запись>
<заголовок/>${title}
<текст/>${text}
</запись>`
}

function is_correct_xml(xml)
{
	var rez = parser.parseFromString(xml, "application/xhtml+xml");
	if (rez.firstElementChild.tagName == "parsererror")
		return false;
	
	return true;
}

function test_text(){
	var checkbox = document.querySelector(".текст input.тест")
	var test = document.querySelector(".текст span.тест")
	var title = document.querySelector(".заголовок input")
	var text = document.querySelector(".текст textarea")
	if (checkbox.checked){
		var rez = parser.parseFromString(get_xml('<h1>'+title.value+'</h1>', text.value), "application/xhtml+xml");
		test.innerHTML = rez.firstElementChild.outerHTML;
		
		test.style.display = "initial";
		text.style.display = "none";
	}else{
		test.style.display = "none";
		text.style.display = "initial";
		text.focus();
	}
}

function save_xml(){
	var title = document.querySelector(".заголовок input").value;
	var text = document.querySelector(".текст textarea").value;
	var xml_text = get_xml(title, text);
	var link_save = document.querySelector(".текст a.save")
	if (!is_correct_xml(xml_text))
	{
		var checkbox = document.querySelector(".текст input.тест")
		checkbox.checked = false;
		checkbox.click();
		link_save.removeAttribute("download");
		link_save.setAttribute("href", '#');
		return;
	}
	
	var xml_file = title.replace(/<[^>]*>|["?\\|*<>:]|\//gm, "_");
	var link_save = document.querySelector(".текст a.save");
	link_save.setAttribute("download", xml_file + ".xml");
	link_save.setAttribute("href", 'data: text/xml,' + encodeURI(xml_text));
	
	var link_update = document.querySelector(".текст a.update_journal");
	link_update.setAttribute("href", '');
	
	fetch("журнал.xml")
	.then((rez)=>rez.text())
	.then(function(text){
		if (encodeURI(xml_file) != xml_file)
			xml_file = encodeURI(xml_file);

		if (xml_file == title)
			text = text.replace("<журнал>", `<журнал>\n\t<запись>${title}</запись>`);
		else
			text = text.replace("<журнал>", `<журнал>\n\t<запись xml="${xml_file}">${title}</запись>`);

		link_update.setAttribute("href", 'data: text/xml,' + encodeURI(text))
	})
}

setTimeout(function(){

		if (   document.querySelector("h1.заголовок").innerText == ""
			&& document.querySelector("span.текст").innerText == ""  )
		{
			document.querySelector("h1.заголовок").innerHTML 
			= `<input id="title" placeholder="Введите заголовок новой записи" style="font: inherit; width: 100%;"/>`;
			
			document.querySelector(".текст").innerHTML 
			= `<label><input accesskey="t" class="тест" type="checkbox" />предпросмотр(t)</label> <a accesskey="s" class="save" href="#">сохранить запись</a> <a accesskey="j" class="update_journal" href="" download="журнал.xml">обновить журнал</a> 
<textarea
	placeholder="Введите текст новой записи."
	style="font: inherit; width: 100%; height: 100vh"
></textarea><span class="тест" style="display: none" />
			<style>
				.update_journal[href=""]{
					display: none;
				}
				
				a[accesskey]:after{
					content: "(" attr(accesskey) ")"
				}
			</style>
	`;
			
			document.querySelector("input.тест").onclick = test_text;
			
			var a = document.querySelector("a.save");
			a.onclick = save_xml;
			a.oncontextmenu = save_xml;
		}
},0)