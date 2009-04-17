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

*/

public class MotionChartController {
    private Opportunity o;
    
    public MotionChartController(ApexPages.StandardController stdController) {
        o = (Opportunity)stdController.getRecord();
    }
    
    public String getSalesHistory(){
		GoogleViz gv = new GoogleViz();
		
		// See http://code.google.com/apis/visualization/documentation/gallery/motionchart.html 
		// to undertstand the Motion Chart data format.
		gv.cols = new list<GoogleViz.col> { 
			new GoogleViz.Col('col0','Opportunity','string'),
		    new GoogleViz.Col('col1','Stage Change Date','date'), 
		    new GoogleViz.Col('col2','Probability','number'),
		    new GoogleViz.Col('col3','Expected Revenue','number')
        };

		o = [SELECT Id, Account.Name FROM Opportunity WHERE Id = :o.Id];
		
		List<OpportunityHistory> opptyHistories = [Select Probability, ExpectedRevenue, CreatedDate, Amount 
												   From OpportunityHistory
												   Where OpportunityId = :o.Id 
												   Order By CreatedDate];	
												   
		for(OpportunityHistory oh : opptyHistories){
			GoogleViz.row r = new GoogleViz.row();
	    	r.cells.add ( new GoogleViz.cell( o.Account.Name ) );
			r.cells.add ( new GoogleViz.cell( oh.CreatedDate ) );
			r.cells.add ( new GoogleViz.cell( oh.Probability ) );
			r.cells.add ( new GoogleViz.cell( oh.ExpectedRevenue ) );
			
			gv.addRow( r );
		}
			
		return gv.toJsonString();					   	
	}
}