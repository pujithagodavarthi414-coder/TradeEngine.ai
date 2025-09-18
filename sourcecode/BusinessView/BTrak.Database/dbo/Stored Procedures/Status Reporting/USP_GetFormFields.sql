Create Procedure USP_GetFormFields   
(  
 @FormId UNIQUEIDENTIFIER = NULL, 
 @FormIdsXml XML = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER  
)  
As    
Begin     
       CREATE TABLE #FormIds
        (
           Id UNIQUEIDENTIFIER
        )

        IF(@FormIdsXml IS NOT NULL)
        BEGIN
              SET @FormId = NULL

              INSERT INTO #FormIds(Id)
              SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
              FROM @FormIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
        END

             SELECT GF.[Id] AS Id,      
                  GF.[GenericFormId],      
                  GF.[Label],      
                   GF.[Key],
				  GF.[Datatype],
                  GF.[Id] AS GenericFormKeyId,
                  GF1.FormName
      from GenericFormKey  GF 
      INNER JOIN GenericForm GF1 ON GF1.Id = GF.GenericFormId
      WHERE (@FormId IS NULL OR GF.GenericFormId = @FormId)
      AND (@FormIdsXml IS NULL OR ( GF.GenericFormId IN (SELECT Id FROM #FormIds)))
and GF.InActiveDateTime is NULL     
GROUP BY GF.[Label], GF.[Key]
   
end