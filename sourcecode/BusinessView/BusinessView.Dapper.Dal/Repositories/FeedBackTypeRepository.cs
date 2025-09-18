using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class FeedBackTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the FeedBackType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(FeedBackTypeDbEntity aFeedBackType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFeedBackType.Id);
					 vParams.Add("@CompanyId",aFeedBackType.CompanyId);
					 vParams.Add("@FeedBackTypeName",aFeedBackType.FeedBackTypeName);
					 vParams.Add("@CreatedDateTime",aFeedBackType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFeedBackType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFeedBackType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFeedBackType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FeedBackTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the FeedBackType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(FeedBackTypeDbEntity aFeedBackType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aFeedBackType.Id);
					 vParams.Add("@CompanyId",aFeedBackType.CompanyId);
					 vParams.Add("@FeedBackTypeName",aFeedBackType.FeedBackTypeName);
					 vParams.Add("@CreatedDateTime",aFeedBackType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aFeedBackType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aFeedBackType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aFeedBackType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FeedBackTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of FeedBackType table.
		/// </summary>
		public FeedBackTypeDbEntity GetFeedBackType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<FeedBackTypeDbEntity>("USP_FeedBackTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the FeedBackType table.
		/// </summary>
		 public IEnumerable<FeedBackTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<FeedBackTypeDbEntity>("USP_FeedBackTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
