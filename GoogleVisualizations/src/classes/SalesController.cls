/*
    Copyright (c) 2008 salesforce.com, inc.
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:
    
    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
    3. The name of the author may not be used to endorse or promote products
       derived from this software without specific prior written permission.
    
    THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
    IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
    OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
    IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
    NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
    THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

	Illustrates somewhat complex query patterns.
*/


public class SalesController {
	
	public String getSalesActivity(){
		
    	GoogleViz gv = new GoogleViz();
                
        gv.cols = new list<GoogleViz.col> { 
			new GoogleViz.Col('col1','Date','date'),
		    new GoogleViz.Col('col2','Cosmo G. Spacely','number'),
		    new GoogleViz.Col('col3','Account Name','string'),
		    new GoogleViz.Col('col4','Opportunity Amount','string')
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
	
	public String getSalesByYear(){
		
    	GoogleViz gv = new GoogleViz();
                
        gv.cols = new list<GoogleViz.col> { 
			new GoogleViz.Col('col1','Year','string'),
		    new GoogleViz.Col('col2','Amount','number')
        };
        
         Map<String, Integer> mapAmountsByYear = new Map<String, Integer>();
        
        for( Opportunity o : [SELECT Amount, FiscalYear
                              FROM Opportunity
                              WHERE IsWon = true
                              ORDER BY FiscalYear ASC]){
            
            String fiscalYear = String.valueOf(o.FiscalYear);
                              	
	        if(!mapAmountsByYear.containsKey(fiscalYear)){
				mapAmountsByYear.put(fiscalYear, o.Amount.intValue());	
			}else{
				Integer currentTotalAmount = mapAmountsByYear.get(fiscalYear);	
				currentTotalAmount += o.Amount.intValue();
				mapAmountsByYear.put(fiscalYear, currentTotalAmount);
	        }
        }
        
        for(String year : mapAmountsByYear.keySet()){
			GoogleViz.row r = new GoogleViz.row();
        	r.cells.add ( new GoogleViz.cell( year ) );
        	r.cells.add ( new GoogleViz.cell( mapAmountsByYear.get(year) ) );
        	                
        	gv.addRow( r );
        }
        
        return gv.toJsonString();
	} 
	
	public String getOpportunitiesByBillingCountry(){
    	
    	GoogleViz gv = new GoogleViz();
        gv.cols = new list<GoogleViz.col> { 
			new GoogleViz.Col('col1','Billing Country','t'),
		    new GoogleViz.Col('col2','Number of Opportunities','n')
        };
                
        Map<String, Integer> mapOpportunityCounts = new Map<String, Integer>();
        //Integer i = 0;
        
        for(Opportunity o : [SELECT Id, Account.BillingCountry
                             FROM Opportunity]){
                             
			//System.debug('######' + i++ +': ' + o);    
			                         	
			if(!mapOpportunityCounts.containsKey(o.Account.BillingCountry)){
				mapOpportunityCounts.put(o.Account.BillingCountry, 0);	
			}
			
			Integer numOpportunities = mapOpportunityCounts.get(o.Account.BillingCountry);	
			numOpportunities++;
			
			mapOpportunityCounts.put(o.Account.BillingCountry, numOpportunities);
     	}
		
		for(String billingCountry : mapOpportunityCounts.keySet()){
			
			Integer numOpportunities = mapOpportunityCounts.get(billingCountry);
			
			GoogleViz.row r = new GoogleViz.row();
            r.cells.add ( new GoogleViz.cell( billingCountry ) );
            r.cells.add ( new GoogleViz.cell( numOpportunities ) );
                
            gv.addRow( r );
        }

        return gv.toJsonString();
	}  
}