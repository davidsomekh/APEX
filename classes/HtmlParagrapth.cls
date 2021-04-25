/****************************
*	EmilK
*
*
******************************/
public class HtmlParagrapth extends HtmlElement{
	
	private List<HtmlElement> m_paragraph_elements = new List<HtmlElement>(); 
	private String m_text;
	
	public HtmlParagrapth(){
		m_text = '';
	}
	
	public String Text{
		get{return m_text;}
		set{m_text = value;}
	}
	
	public List<HtmlElement> Elements{
		get{return m_paragraph_elements;}
		set{m_paragraph_elements = value;}
	}
	
	public override String ToHtmlString(){
		
		String htmlString = '<p>';
		// add text to paragraph
		htmlString += m_text;
		
		// write elements inside paragraph
		for(HtmlElement elem : m_paragraph_elements){
			htmlString += elem.ToHtmlString();
		}
		htmlString += '</p>';
		return htmlString;	
	} 
}