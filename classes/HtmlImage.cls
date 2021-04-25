/********************************************
*	EmilK
*	HtmlImage - write image on html format
*
*********************************************/
public class HtmlImage extends HtmlElement{

	private String m_url;
	
	public HtmlImage(){
		m_url = '';
	}
	
	public HtmlImage(String image_source){
		m_url = image_source;
	}
	
	public String Url{
		get{return m_url;}
		set{m_url = value;}
	}
	
	public override String ToHtmlString(){
		
		String htmlString = '<img src="'+m_url+'"';
		// get image height and width string if any
		htmlString += getHeightAndWidthString();
		// close tag
		htmlString += '/>';
		
		return htmlString;
	}
}