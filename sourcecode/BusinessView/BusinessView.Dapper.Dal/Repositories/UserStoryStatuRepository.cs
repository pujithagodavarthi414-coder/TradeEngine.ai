using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryStatuDbEntity aUserStoryStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryStatu.Id);
					 vParams.Add("@Status",aUserStoryStatu.Status);
					 vParams.Add("@CompanyId",aUserStoryStatu.CompanyId);
					 vParams.Add("@CreatedDateTime",aUserStoryStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryStatu.UpdatedByUserId);
					 vParams.Add("@StatusHexValue",aUserStoryStatu.StatusHexValue);
					 vParams.Add("@StatusColor",aUserStoryStatu.StatusColor);
					 vParams.Add("@IsOwnerEditable",aUserStoryStatu.IsOwnerEditable);
					 vParams.Add("@IsUserStoryEditable",aUserStoryStatu.IsUserStoryEditable);
					 vParams.Add("@IsEstimatedTimeEditable",aUserStoryStatu.IsEstimatedTimeEditable);
					 vParams.Add("@IsDeadLineEditable",aUserStoryStatu.IsDeadLineEditable);
					 vParams.Add("@IsStatusEditable",aUserStoryStatu.IsStatusEditable);
					 vParams.Add("@IsBugPriorityEditable",aUserStoryStatu.IsBugPriorityEditable);
					 vParams.Add("@IsBugCausedUserEditable",aUserStoryStatu.IsBugCausedUserEditable);
					 vParams.Add("@IsDependencyEditable",aUserStoryStatu.IsDependencyEditable);
					 vParams.Add("@CanArchive",aUserStoryStatu.CanArchive);
					 vParams.Add("@IsArchived",aUserStoryStatu.IsArchived);
					 vParams.Add("@ArchivedDateTime",aUserStoryStatu.ArchivedDateTime);
					 vParams.Add("@CanPark",aUserStoryStatu.CanPark);
					 int iResult = vConn.Execute("USP_UserStoryStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryStatuDbEntity aUserStoryStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryStatu.Id);
					 vParams.Add("@Status",aUserStoryStatu.Status);
					 vParams.Add("@CompanyId",aUserStoryStatu.CompanyId);
					 vParams.Add("@CreatedDateTime",aUserStoryStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryStatu.UpdatedByUserId);
					 vParams.Add("@StatusHexValue",aUserStoryStatu.StatusHexValue);
					 vParams.Add("@StatusColor",aUserStoryStatu.StatusColor);
					 vParams.Add("@IsOwnerEditable",aUserStoryStatu.IsOwnerEditable);
					 vParams.Add("@IsUserStoryEditable",aUserStoryStatu.IsUserStoryEditable);
					 vParams.Add("@IsEstimatedTimeEditable",aUserStoryStatu.IsEstimatedTimeEditable);
					 vParams.Add("@IsDeadLineEditable",aUserStoryStatu.IsDeadLineEditable);
					 vParams.Add("@IsStatusEditable",aUserStoryStatu.IsStatusEditable);
					 vParams.Add("@IsBugPriorityEditable",aUserStoryStatu.IsBugPriorityEditable);
					 vParams.Add("@IsBugCausedUserEditable",aUserStoryStatu.IsBugCausedUserEditable);
					 vParams.Add("@IsDependencyEditable",aUserStoryStatu.IsDependencyEditable);
					 vParams.Add("@CanArchive",aUserStoryStatu.CanArchive);
					 vParams.Add("@IsArchived",aUserStoryStatu.IsArchived);
					 vParams.Add("@ArchivedDateTime",aUserStoryStatu.ArchivedDateTime);
					 vParams.Add("@CanPark",aUserStoryStatu.CanPark);
					 int iResult = vConn.Execute("USP_UserStoryStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryStatus table.
		/// </summary>
		public UserStoryStatuDbEntity GetUserStoryStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryStatuDbEntity>("USP_UserStoryStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryStatus table.
		/// </summary>
		 public IEnumerable<UserStoryStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryStatuDbEntity>("USP_UserStoryStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
