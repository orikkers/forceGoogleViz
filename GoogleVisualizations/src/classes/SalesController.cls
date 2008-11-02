public class SalesController {
	public String getSalesActivity(){
		GoogleViz gv = new GoogleViz();
		
		gv.cols = new list<GoogleViz.col> { 
            new GoogleViz.Col('col1','Date','d'),
            new GoogleViz.Col('col2','Cosmo G. Spacely','n'),
            new GoogleViz.Col('col3','Account Name','t'),
            new GoogleViz.Col('col4','Opportunity Amount','t')
        };
        	
        Integer numOpportunities = 1;
        for( Opportunity o : [SELECT Id, Name, Amount, CloseDate, Account.Name, Owner.Name
        					  FROM Opportunity
        					  WHERE IsWon = true
        					  ORDER BY CloseDate ASC]){

        	GoogleViz.row r = new GoogleViz.row();
	        r.cells.add ( new GoogleViz.cell( o.CloseDate ) );
	        r.cells.add ( new GoogleViz.cell( numOpportunities ) );
	        r.cells.add ( new GoogleViz.cell( o.Account.Name ) );
	        r.cells.add ( new GoogleViz.cell( o.Amount ) );
	        
	        gv.addRow( r );
	        numOpportunities++;
		}

		return gv.toJsonString();
	}  
}