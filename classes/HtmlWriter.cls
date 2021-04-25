/*********************************
*	EmilK
*	html writer
*
**********************************/
public class HtmlWriter {

	private List<HtmlElement> m_page_elements = new List<HtmlElement>();
	private String m_headerText;
	
	public HtmlWriter(){
		m_headerText = '';
	}
		
	public HtmlParagrapth addParagraph(){
		
		HtmlParagrapth newPAragraph = new HtmlParagrapth();
		m_page_elements.add(newPAragraph);
		
		return newPAragraph;
	}
	
	public HtmlLink addLink(){
		HtmlLink newLink = new HtmlLink();
		m_page_elements.add(newLink);
		
		return newLink;
	}
	 
	public HtmlTable addTable(){
		
		HtmlTable newTable = new HtmlTable();
		m_page_elements.add(newTable);
		
		return newTable;
	}
	
	public String HeaderText{
		set{ m_headerText = value;}
		get{return m_headerText;}
	}
	
	public String ToHtmlString(){
		
		String htmlString = '<head>' + m_headerText + '</head>\n';
		htmlString+= '<body>\n';
		for(HtmlElement anyElem : m_page_elements){
			htmlString += anyElem.ToHtmlString();
		}
		htmlString+= '</body>\n';
		
		return htmlString;	
	}
}