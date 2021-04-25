/**********************************
*	EmilK
*
*
*
***********************************/
public class HtmlRow extends HtmlElement{
	
	static testMethod void myTest() {

       HtmlRow h = new HtmlRow();
       String ss;
       Boolean b = FALSE;
       HtmlCell d = new HtmlCell(ss,b);
       HtmlCell d2 = new HtmlCell(ss,b);
       
       Set<HtmlCell> s1 = new Set<HtmlCell>();
	   s1.add(d);
	   s1.add(d2);
    
       
       //List<HtmlCell> Cells = new List<HtmlCell>();
      // h.Cells(s1);
      // Cells.set(s1);
      
      h.Cells.add(new HtmlCell(ss,b));
      
     // List<HtmlCell> c = new List<HtmlCell>();
      //c = h.Cells();
       
       ss = h.ToHtmlString();
       
     }
	
	
	private List<HtmlCell> m_cells = new List<HtmlCell>();
	
	public List<HtmlCell> Cells{
		get{ return m_cells;}
		set{ m_cells = value;}
	}
	
	public override String ToHtmlString(){
		
		String HtmalString = '<tr>\n';
				
		for (HtmlCell anyCell : m_cells){
			HtmalString += '\t' + anyCell.ToHtmlString();
		}
		HtmalString += '</tr>\n';
		return HtmalString;
	}
}