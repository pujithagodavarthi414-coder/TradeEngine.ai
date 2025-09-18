using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ControllerApiNameRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ControllerApiName table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ControllerApiNameDbEntity aControllerApiName)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aControllerApiName.Id);
					 vParams.Add("@ActionPath",aControllerApiName.ActionPath);
					 vParams.Add("@IsActive",aControllerApiName.IsActive);
					 vParams.Add("@AccessAll",aControllerApiName.AccessAll);
					 vParams.Add("@CreatedDateTime",aControllerApiName.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aControllerApiName.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aControllerApiName.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aControllerApiName.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ControllerApiNameInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ControllerApiName table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ControllerApiNameDbEntity aControllerApiName)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aControllerApiName.Id);
					 vParams.Add("@ActionPath",aControllerApiName.ActionPath);
					 vParams.Add("@IsActive",aControllerApiName.IsActive);
					 vParams.Add("@AccessAll",aControllerApiName.AccessAll);
					 vParams.Add("@CreatedDateTime",aControllerApiName.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aControllerApiName.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aControllerApiName.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aControllerApiName.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ControllerApiNameUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ControllerApiName table.
		/// </summary>
		public ControllerApiNameDbEntity GetControllerApiName(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ControllerApiNameDbEntity>("USP_ControllerApiNameSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ControllerApiName table.
		/// </summary>
		 public IEnumerable<ControllerApiNameDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ControllerApiNameDbEntity>("USP_ControllerApiNameSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ControllerApiName table by a foreign key.
		/// </summary>
		public List<ControllerApiNameDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ControllerApiNameDbEntity>("USP_ControllerApiNameSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the ControllerApiName table by a foreign key.
		/// </summary>
		public List<ControllerApiNameDbEntity> SelectAllByUpdatedByUserId(Guid? updatedByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UpdatedByUserId",updatedByUserId);
				 return vConn.Query<ControllerApiNameDbEntity>("USP_ControllerApiNameSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
