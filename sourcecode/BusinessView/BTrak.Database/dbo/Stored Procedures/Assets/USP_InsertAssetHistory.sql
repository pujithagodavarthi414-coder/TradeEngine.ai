-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Save AssetHistory
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_InsertAssetHistory  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
--                             @AssetId = '614B89E1-6A7E-45F1-BDC5-5F4120649FB0',
--                             @AssetHistoryJson = '{"AssetsFieldsChangedList":[
--                                                                              {"FieldName":"AssetName","OldValue":"Chair","NewValue":"Wheel Chair","Description":"AssetName is changed from Chair to Wheel Chair"},
--                                                                              {"FieldName":"AssetNumber","OldValue":"Ch 345","NewValue":"W_Ch 345","Description":"AssetNumber is changed from Ch 345 to W_Ch 345"},
--                                                                              {"FieldName":"Cost","OldValue":"15","NewValue":"20","Description":"Cost of asset is changed from 15to20"},
--                                                                              {"FieldName":"IsWriteOff","OldValue":"0","NewValue":"1","Description":"IsWriteOff is changed from 0 to 1"}
--                                                                            ]
--                                                 }'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_InsertAssetHistory]
(
    @AssetId UNIQUEIDENTIFIER = NULL,
    @AssetHistoryJson NVARCHAR(MAX) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON  
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@AssetId = '00000000-0000-0000-0000-000000000000') SET @AssetId = NULL

	    IF(@AssetId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Asset')

		END
		ELSE
		BEGIN

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        DECLARE @AssetHistoryId UNIQUEIDENTIFIER = NEWID()

        INSERT INTO [dbo].[AssetHistory](
                    [Id],
                    [AssetId],
                    [AssetHistoryJson],
                    [CreatedByUserId],
                    [CreatedDateTime])
             SELECT @AssetHistoryId,
                    @AssetId,
                    @AssetHistoryJson,
                    @OperationsPerformedBy,
                    GETDATE()
        
        SELECT Id FROM [dbo].[AssetHistory] WHERE Id = @AssetHistoryId
		END
    END TRY
    BEGIN CATCH
             EXEC [dbo].[USP_GetErrorInformation]
    END CATCH
END
GO