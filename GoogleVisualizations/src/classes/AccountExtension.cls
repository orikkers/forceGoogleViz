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

	Illustrates fairly simplistic query patterns.
*/

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