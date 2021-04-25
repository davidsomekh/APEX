/******************************************
*	EmilK
*	Html table represents a table writen in html
*
*******************************************/
public class HtmlTable extends HtmlElement{

	private List<HtmlRow> m_rows = new List<HtmlRow>();
	private List<HtmlCell> m_columns = new List<HtmlCell>();
	private Integer m_borderWidth = 0;
	
	public List<HtmlCell> Columns{
		get{return m_columns;}
		set{m_columns = value;}
	}
	
	public void addColumn(String columnName){
		// add a header cell to the columns
		m_columns.add(new HtmlCell(columnName, true));
	}
	
	public Integer BorderWidth{
		get{return m_borderWidth;}
		set{ if (value >= 0) m_borderWidth = value;}
	}
	
	public List<HtmlRow> Rows{
		get{return m_rows;}
		set{m_rows = value;}
	}
	
	public override String ToHtmlString(){
		
		String HtmalString = '<table border = "' + m_borderWidth + '">\n';
		HtmalString += '<tr>';
		for (HtmlCell anyColumn : m_columns){
			
			HtmalString += '\t' + anyColumn.ToHtmlString();
		}
		HtmalString += '</tr>';
		for (HtmlRow anyRow : m_rows){
			HtmalString += anyRow.ToHtmlString();
		}
		
		HtmalString += '</table>\n';
		return HtmalString;
	}
}