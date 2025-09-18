CREATE PROCEDURE USP_AlterSchemaOfAnObject
(
    @ObjectName NVARCHAR(MAX),
    @SchemaName NVARCHAR(250)
)
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @Name VARCHAR(50)

        DECLARE @SqlQuery NVARCHAR(100)

        DECLARE @SchemaOutput NVARCHAR(MAX) = ''

		DECLARE @ObjectsCount INT

		DECLARE @SName VARCHAR(50)

	    DECLARE @OName VARCHAR(50)

        IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = @SchemaName))
        BEGIN

            EXEC ('CREATE SCHEMA  [' + @SchemaName + '] AUTHORIZATION [dbo]')

        END

		DECLARE @Object_Names TABLE
		(
			Id INT IDENTITY(1,1),
			ObjectName Varchar(250)
		)

		INSERT INTO @Object_Names(ObjectName)
		SELECT VALUE FROM STRING_SPLIT(@ObjectName,',') 
				
		SELECT @ObjectsCount = COUNT(VALUE) FROM STRING_SPLIT(@ObjectName,',') 

        WHILE (@ObjectsCount > 0)        
		BEGIN	
			
			  SELECT @Name = ObjectName FROM @Object_Names WHERE Id = @ObjectsCount           			  
             
			  SELECT @SName = SCHEMA_NAME((SELECT SCHEMA_ID FROM sys.all_objects WHERE [name] = @Name))
             
			  IF(@SName = @SchemaName)             
			  BEGIN
             
			      SELECT @SchemaOutput = @SchemaOutput + ', Choose another schema'
             
			  END             
			  ELSE             
			  BEGIN
                  
				   SET @SqlQuery = 'ALTER SCHEMA ' + @SchemaName + ' TRANSFER ' + @SName + '.[' + @Name + ']'
                  
				   EXEC (@SqlQuery)				  				  
				  
				   SELECT @OName = name FROM sys.all_objects WHERE [name] = @Name
				  
				   IF(@Name = @OName)				  
				   BEGIN
					
						 SELECT @SchemaOutput = @SchemaOutput + ', Schema changed successfully'
				   
				   END				   
				   ELSE				   
				   BEGIN
					
						SELECT @SchemaOutput = @SchemaOutput + ', Object Name is not found'
				   
				   END
              
			  END
            
			SET @ObjectsCount = @ObjectsCount - 1
        
		END
        
		SELECT VALUE FROM STRING_SPLIT(@SchemaOutput,',')
    
	END TRY    
	BEGIN CATCH
    
	    EXEC USP_GetErrorInformation
    
	END CATCH
END
