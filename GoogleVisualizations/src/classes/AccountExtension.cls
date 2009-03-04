public class AccountExtension {
    
    private Account a;
    
    public AccountExtension(ApexPages.StandardController stdController) {
        a = (Account)stdController.getRecord();
    }

    public String getOpportunities(){
    	List<Opportunity> opportunities = [SELECT Name, Amount 
        				 				   FROM Opportunity
        				 				   WHERE AccountId = :a.Id];
        				 				   
    	GoogleViz gv = new GoogleViz();
        gv.cols = new list<GoogleViz.col> { 
			new GoogleViz.Col('col1','Opportunity Name','t'),
		    new GoogleViz.Col('col2','Amount','n')
        };
         
        for(Opportunity o : opportunities){
			
			GoogleViz.row r = new GoogleViz.row();
            r.cells.add ( new GoogleViz.cell( o.Name ) );
            r.cells.add ( new GoogleViz.cell( o.Amount ) );
                
            gv.addRow( r );
        }

        return gv.toJsonString();
	}  
}