using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class BugPriorityRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the BugPriority table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(BugPriorityDbEntity aBugPriority)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBugPriority.Id);
					 vParams.Add("@PriorityName",aBugPriority.PriorityName);
					 vParams.Add("@Color",aBugPriority.Color);
					 vParams.Add("@CreatedDateTime",aBugPriority.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBugPriority.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBugPriority.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBugPriority.UpdatedByUserId);
					 vParams.Add("@Description",aBugPriority.Description);
					 int iResult = vConn.Execute("USP_BugPriorityInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the BugPriority table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(BugPriorityDbEntity aBugPriority)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aBugPriority.Id);
					 vParams.Add("@PriorityName",aBugPriority.PriorityName);
					 vParams.Add("@Color",aBugPriority.Color);
					 vParams.Add("@CreatedDateTime",aBugPriority.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aBugPriority.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aBugPriority.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aBugPriority.UpdatedByUserId);
					 vParams.Add("@Description",aBugPriority.Description);
					 int iResult = vConn.Execute("USP_BugPriorityUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of BugPriority table.
		/// </summary>
		public BugPriorityDbEntity GetBugPriority(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<BugPriorityDbEntity>("USP_BugPrioritySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the BugPriority table.
		/// </summary>
		 public IEnumerable<BugPriorityDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<BugPriorityDbEntity>("USP_BugPrioritySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
