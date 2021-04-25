/********************************************
*	EmilK
*	HtmlLink
*
***********************************************/
public class HtmlLink extends HtmlElement{
	
	private String m_url;
	private String m_title;
	
	public String Url{
		get{return m_url;}
		set{m_url = value;}
	}
	
	public String Title{
		get{return m_title;}
		set{m_title = value;}
	}
	
	public HtmlLink(){
		m_url ='';
		m_title = '';
	}
	
	public override String ToHtmlString(){
		
		String htmlString = '<a href = "'+m_url+'">';
		htmlString += m_title;
		htmlString += '</a>';
		return htmlString;
	}
}