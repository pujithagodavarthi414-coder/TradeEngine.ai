CREATE PROCEDURE [dbo].[USP_GetWeekdays]
(
  @WeekDayId INT = NULL,
  @WeekDayName NVARCHAR(250) = NULL,
  @IsWeekEnd BIT = NULL,
  @IsHalfDay BIT= NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	       	 
		    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
            IF (@HavePermission = '1')
            BEGIN
	
		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   		   
	           SELECT [Id] [WeekId], 
					[WeekDay] [WeekDayId],
					  WeekDayName,
					  IsHalfDay,
					  IsWeekend,
					  SortOrder,
		              CreatedByUserId,
			    	  CreatedDateTime,
			    	  [TimeStamp],
		              TotalCount = COUNT(1) OVER()
		       FROM  [dbo].[WeekDays] WITH (NOLOCK)

		       WHERE CompanyId = @CompanyId 
		             AND (@WeekDayId IS NULL OR [WeekDay] = @WeekDayId)
		             AND (@WeekDayName IS NULL OR WeekDayName = @WeekDayName)
			    	 AND (@IsWeekEnd IS NULL OR IsWeekend = @IsWeekEnd)
			    	 AND (@IsHalfDay IS NULL OR IsHalfDay   = @IsHalfDay)
		             AND (@IsArchived IS NULL OR (@IsArchived = 0 AND InActiveDateTime IS NULL)
			    	 OR  (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))
		       ORDER BY SortOrder ASC 	 
    
	       END
	    ELSE
        BEGIN
                
		  RAISERROR (@HavePermission,11, 1)
                   
       END  
	   END TRY  
	   BEGIN CATCH 
		
		   THROW

	  END CATCH
END