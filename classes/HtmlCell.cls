/************************************
*	EmilK
*
*
**************************************/
public class HtmlCell extends HtmlElement{
	
	private String m_text;
	private String m_cellTag;
	
	public String Text{
		set{ m_text = value;}
		get{return m_text;}
	}
	
	public HtmlCell(String text, Boolean isHeaderCell){
		
		 this(isHeaderCell);
		 m_text = text;
	}
	
	public HtmlCell(Boolean isHeaderCell){
		
		if (isHeaderCell)
			m_cellTag = 'th';
		else
			m_cellTag = 'td';
	}
	
	public override String ToHtmlString(){
		
		String HtmlString = '<' + m_cellTag + '>';
		HtmlString += m_text;
		HtmlString +=  '</' + m_cellTag + '>';
		
		return HtmlString;
	}
}