----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-15 00:00:00.000'
-- Purpose      To Get All Invoice Schedules by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetInvoiceSchedules] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @InvoiceScheduleId = '7E142481-E7E7-4545-9FEA-35D155BD4E26', @InvoiceId = '4B1B4372-38EA-4617-B411-2FE704E41CEC'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetInvoiceSchedules]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @InvoiceScheduleId UNIQUEIDENTIFIER = NULL,
	@InvoiceId UNIQUEIDENTIFIER = NULL,   
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
    @SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

           IF(@SearchText   = '') SET @SearchText   = NULL

		   SET @SearchText = '%'+ @SearchText +'%';              

           IF(@InvoiceScheduleId = '00000000-0000-0000-0000-000000000000') SET @InvoiceScheduleId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT INS.Id AS InvoiceScheduleId,
				  INS.ScheduleName,	
				  INS.InvoiceId,
				  INS.CurrencyId,
				  INS.ScheduleStartDate AS StartDate,
				  INS.ScheduleTypeId,
				  INS.Extension,
				  INS.RatePerHour,
				  INS.HoursPerSchedule,				  
				  INS.ExcessHoursRate,
				  INS.ExcessHours,
				  INS.ScheduleSequenceId,
				  INS.ScheduleSequenceQuantity,				   
				  INW.InvoiceNumber AS Invoice,
				  CR.CurrencyCode,
				  C.CompanyLogo,
				  INW.CreatedDateTime AS IssueDate,  
				  INW.DueDate AS NextDueDate,
				  INW.Notes,
				  INW.Terms,
				  INS.Description,
				  INS.SendersName,
				  INS.SendersAddress,
				  INS.CompanyId,
				  INS.CreatedDateTime,
                  INS.CreatedByUserId,
				  INS.UpdatedDateTime,
				  INS.UpdatedByUserId,
				  INS.InActiveDateTime,
                  INS.[TimeStamp],  
                  TotalCount = COUNT(1) OVER()
           FROM InvoiceSchedule AS INS
		   LEFT JOIN Invoice_New INW ON INW.Id = INS.InvoiceId
		   LEFT JOIN Currency CR ON CR.Id = INS.CurrencyId
		   LEFT JOIN Company C ON C.Id = INS.CurrencyId
           WHERE INS.CompanyId = @CompanyId                
                AND (@SearchText IS NULL OR (INS.ScheduleName LIKE @SearchText ))   
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND INS.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND INS.InactiveDateTime IS NULL))
                AND (@InvoiceScheduleId IS NULL OR INS.Id = @InvoiceScheduleId)
				AND (@InvoiceId IS NULL OR INW.Id = @InvoiceId)
				AND (@DateFrom IS NULL OR INS.ScheduleStartDate >= @DateFrom)
				AND (@DateTo IS NULL OR INS.ScheduleStartDate <= @DateTo)         
           ORDER BY INS.ScheduleName ASC
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
GO
