-------------------------------------------------------------------------------
-- EXEC [USP_UpsertChannelMember]
-- @OperationsPerformedBy ='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ChannelId = '11B4393C-3ADF-499B-BB6F-59AE5873736D',@MemberUserGuids = N'<?xml version="1.0" encoding="utf-16"?>
-- <GenericListOfChannelMemberModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
-- <ListItems>
-- <ChannelMemberModel>
-- <MemberUserId>127133F1-4427-4149-9DD6-B02E0E036971</MemberUserId>
-- </ChannelMemberModel>
-- <ChannelMemberModel>
-- <MemberUserId>127133F1-4427-4149-9DD6-B02E0E036972</MemberUserId>
-- </ChannelMemberModel>
-- </ListItems>
-- </GenericListOfChannelMemberModel>',
-- @IsDeleted = 0

-- update reference
-- EXEC [USP_UpsertChannelMember]
-- @OperationsPerformedBy ='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ChannelId = '11B4393C-3ADF-499B-BB6F-59AE5873736D',@MemberUserGuids = N'<?xml version="1.0" encoding="utf-16"?>
-- <GenericListOfChannelMemberModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
-- <ListItems>
-- <ChannelMemberModel>
-- <ChannelMemberId>2A4D95C4-A56F-41DB-9F4C-CAE5C89453B0</ChannelMemberId>
-- <MemberUserId>127133F1-4427-4149-9DD6-B02E0E036971</MemberUserId>
-- <TimeStamp>0x0000000000001624</TimeStamp>
-- </ChannelMemberModel>
-- <ChannelMemberModel>
-- <ChannelMemberId>C60B0A06-8E14-4508-8B5D-2FE1C07687A7</ChannelMemberId>
-- <MemberUserId>127133F1-4427-4149-9DD6-B02E0E036972</MemberUserId>
-- <TimeStamp>0x000000000000161F</TimeStamp>
-- </ChannelMemberModel>
-- <ChannelMemberModel>
-- <MemberUserId>0B2921A9-E930-4013-9047-670B5352F308</MemberUserId>
-- </ChannelMemberModel>
-- </ListItems>
-- </GenericListOfChannelMemberModel>',
-- @IsDeleted = 1

-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertChannelMember]
(
  @ChannelId UNIQUEIDENTIFIER = NULL,
  @ChannelName nvarchar(800) = NULL,
  @MemberUserGuids XML = NULL,
  @IsDeleted BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @ProjectId UNIQUEIDENTIFIER = NULL
) 
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	  IF(@HavePermission = '1')
      BEGIN

	  IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	  IF (@ChannelId = '00000000-0000-0000-0000-000000000000') SET @ChannelId = NULL

	  IF (@ChannelId IS NULL) 
	  BEGIN
	  
	      SET @ChannelId = (select Id From Channel WHERE ProjectId = @ProjectId )
	  
	  END

	  DECLARE @UserIdsCount INT =  (SELECT Count(1) FROM @MemberUserGuids.nodes('/GenericListOfChannelMemberModel/ListItems/ChannelMemberModel') AS x(y))

	  IF(@ChannelId IS NULL)
	  BEGIN
		   
		   RAISERROR(50011,16, 2, 'Channel')

	  END
	  ELSE IF(@UserIdsCount = 0)
	  BEGIN
		   
		   RAISERROR(50011,16, 2, 'Users')

	  END
	  ELSE 
	  BEGIN

			  IF(@MemberUserGuids IS NOT NULL)
			  BEGIN

			      DECLARE @Currentdate DATETIME =  GETDATE()

                  DECLARE @Temp TABLE
                  (
		              RowNumber INT IDENTITY(1,1),
					  ChannelMemberId UNIQUEIDENTIFIER,
                      MemberUserId UNIQUEIDENTIFIER,
                      IsExist BIT,
					  NewChannelMemberId UNIQUEIDENTIFIER,
					  [TimeStamp] NVARCHAR(100) NULL
                  )

                  INSERT INTO @Temp(ChannelMemberId,MemberUserId,NewChannelMemberId,[TimeStamp])
                  SELECT CASE WHEN  [TABLE].RECORD.value('(ChannelMemberId)[1]', 'NVARCHAR(500)') = ' ' THEN NULL ELSE [TABLE].RECORD.value('(ChannelMemberId)[1]', 'NVARCHAR(500)') END,
				  CASE WHEN  [TABLE].RECORD.value('(MemberUserId)[1]', 'NVARCHAR(500)') = ' ' THEN NULL ELSE [TABLE].RECORD.value('(MemberUserId)[1]', 'NVARCHAR(500)') END,
				  NEWID(),
				  CASE WHEN [TABLE].RECORD.value('(TimeStamp)[1]', 'NVARCHAR(100)') = ' ' THEN NULL  ELSE [TABLE].RECORD.value('(TimeStamp)[1]', 'NVARCHAR(100)') END
				  FROM @MemberUserGuids.nodes('/GenericListOfChannelMemberModel/ListItems/ChannelMemberModel') AS [TABLE](RECORD)

	              DECLARE @MemberUserIdsCount INT =  (SELECT COUNT (1) FROM @Temp)
				  DECLARE @ChannelMemberId UNIQUEIDENTIFIER = NULL
        
                  UPDATE @Temp SET IsExist = CASE WHEN CM.MemberUserId IS NULL THEN 0 ELSE 1 END
                  FROM @Temp Temp 
				  LEFT JOIN [ChannelMember] CM ON (CM.Id = Temp.ChannelMemberId  OR CM.MemberUserId=Temp.MemberUserId)
				  AND CM.ChannelId=@ChannelId

				   INSERT INTO [dbo].[ChannelMember](
                                 Id,
                                 ChannelId,
                                 MemberUserId,
                                 ActiveFrom,
                                 ActiveTo,
                                 InActiveDateTime,
                                 CreatedDateTime,
                                 CreatedByUserId)
                          SELECT NEWID(),
                                 @ChannelId,
                                 MemberUserId,
                                 @Currentdate,
                                 CASE WHEN @IsDeleted = 1 THEN @Currentdate ELSE NULL END,
                                 CASE WHEN @IsDeleted = 1 THEN @Currentdate ELSE NULL END,
                                 @Currentdate,
                                 @OperationsPerformedBy
                            FROM @Temp where IsExist=0
                    
					UPDATE [ChannelMember] 
					    SET ChannelId = @ChannelId,
						    MemberUserId =  t.MemberUserId,
							ActiveFrom = @Currentdate,
							ActiveTo = CASE WHEN @IsDeleted = 1 THEN @Currentdate ELSE NULL END,
							InActiveDateTime = CASE WHEN @IsDeleted = 1 THEN @Currentdate ELSE NULL END,
							UpdatedDateTime = @Currentdate,
							UpdatedByUserId = @OperationsPerformedBy
							FROM @Temp t join ChannelMember cm on (cm.MemberUserId=t.MemberUserId and cm.ChannelId=@ChannelId )where IsExist=1
				  END

				  SELECT @ChannelId ChannelId

              END
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
