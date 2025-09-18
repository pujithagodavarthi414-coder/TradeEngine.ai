-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-11-01 00:00:00.000'
-- Purpose      To Execute Dynamic Query
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_ExecuteDynamicQuery] @WidgetQuery='select * from [User]'
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ExecuteDynamicQuery]
(
   @WidgetQuery NVARCHAR(MAX) = NULL,
   @FilterQuery NVARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN

			IF(@FilterQuery IS NOT NULL OR @FilterQuery <> '')
			BEGIN
				SET @WidgetQuery = 'SELECT * FROM ( ' + @WidgetQuery + ' ) DUMMYBTRAKWIDGETTABLE ' +  @FilterQuery
			END

			DECLARE @WidgetQueryJson NVARCHAR(MAX) = 'SELECT (' + @WidgetQuery + ' FOR JSON PATH,INCLUDE_NULL_VALUES) AS Query'

			EXEC SP_EXECUTESQL @WidgetQueryJson

		END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO