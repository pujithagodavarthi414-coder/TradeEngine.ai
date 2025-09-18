using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class GoalReplanTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the GoalReplanType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(GoalReplanTypeDbEntity aGoalReplanType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalReplanType.Id);
					 vParams.Add("@GoalReplanTypeName",aGoalReplanType.GoalReplanTypeName);
					 vParams.Add("@CreatedDateTime",aGoalReplanType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalReplanType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalReplanType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalReplanType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_GoalReplanTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the GoalReplanType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(GoalReplanTypeDbEntity aGoalReplanType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aGoalReplanType.Id);
					 vParams.Add("@GoalReplanTypeName",aGoalReplanType.GoalReplanTypeName);
					 vParams.Add("@CreatedDateTime",aGoalReplanType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aGoalReplanType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aGoalReplanType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aGoalReplanType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_GoalReplanTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of GoalReplanType table.
		/// </summary>
		public GoalReplanTypeDbEntity GetGoalReplanType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<GoalReplanTypeDbEntity>("USP_GoalReplanTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the GoalReplanType table.
		/// </summary>
		 public IEnumerable<GoalReplanTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<GoalReplanTypeDbEntity>("USP_GoalReplanTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
