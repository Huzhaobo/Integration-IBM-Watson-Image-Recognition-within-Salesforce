public class IBMWatsonImageRecognization {
    Private String caseId {get;set;}
    Private Case c{get;set;}
    Private HttpResponse result {get;set;}
    public List<Classification> fetchClassifications {get;set;}
    public IBMWatsonImageRecognization(ApexPages.StandardController con){
        caseId = con.getId() ; 
        c=[Select Id ,Upload_Image_URL__c from Case where id =:caseId Limit 1] ; 
        result = getImageDetails();
        fetchClassifications = parseJson(result.getBody()) ; 
    }
    
    public HTTPResponse getImageDetails(){
        HttpRequest req = new HttpRequest();
        String baseURL = buildImageRecognizationURL(c.Upload_Image_URL__c, '9c1be84069f7af00896771d0dfd8b1bb4c822d5b');
        req.setEndpoint(baseURL);
        req.setMethod('POST');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res ;   
    }
    public String buildImageRecognizationURL(String imageURL ,String API_KEY ){
        String baseURL = 'https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key='+API_KEY+'&url='+imageURL+'&version=2016-05-20';
        return baseURL ;
    }
    public list<Classification> parseJson(String jsonRes){
        list<Classification> classif = new list<Classification>() ;
        Map<String, Object> m =(Map<String, Object>)JSON.deserializeUntyped(jsonRes);
        List<Object> a = (List<Object>)m.get('images');
        Map<String, Object> a2 =(Map<String, Object>)a[0];
        List<Object> a33 = (List<Object> )a2.get('classifiers') ; 
        Map<String, Object> a444 =(Map<String, Object>)a33[0];
        List<Object> a555= (List<Object>)a444.get('classes');
        for(Object o :a555){
            Map<String, Object> classiObj =(Map<String, Object>)o;
            Classification cNew = new Classification(); 
            for(String ss : classiObj.keySet()){
                if(ss=='class'){
                    cNew.classificaions = (String)classiObj.get(ss) ;
                }
                if(ss=='score'){
                    cNew.percentage = (Decimal)classiObj.get(ss) ;
                }
            }
            classif.add(cNew);
        }
        return classif;
    }
    
    public class Classification {
        public String classificaions {get;set;}
        public Decimal percentage {get;set;}
    }
    
}