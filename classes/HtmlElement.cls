/*********************************
*	EmilK
*	HtmlElement - contains general HTML
*	properties that a commonly used
***********************************/
public virtual class HtmlElement {
	
	protected Integer m_height;
	protected Integer m_width;
	
	public Integer Height{
		set{m_height = value;}
		get{return m_height;}
	}
	
	public Integer Width{
		set{m_width = value;}
		get{return m_width;}
	}

	protected String getHeightAndWidthString(){
		String htmlHeightWidth = '';
		
		if (m_height != null){
			htmlHeightWidth +='height = "'+m_height+'" ';
		}
		
		if(m_width != null){
			htmlHeightWidth +='width = "'+m_width+'" ';
		}
		return htmlHeightWidth;
	}	

	public virtual String ToHtmlString(){
		return '';	
	} 
}