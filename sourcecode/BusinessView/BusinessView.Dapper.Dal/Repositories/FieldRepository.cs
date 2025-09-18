using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class FieldRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Field table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(FieldDbEntity aField)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aField.Id);
					 vParams.Add("@FieldName",aField.FieldName);
					 vParams.Add("@CreatedDateTime",aField.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aField.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aField.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aField.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FieldInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Field table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(FieldDbEntity aField)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aField.Id);
					 vParams.Add("@FieldName",aField.FieldName);
					 vParams.Add("@CreatedDateTime",aField.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aField.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aField.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aField.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_FieldUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Field table.
		/// </summary>
		public FieldDbEntity GetField(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<FieldDbEntity>("USP_FieldSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Field table.
		/// </summary>
		 public IEnumerable<FieldDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<FieldDbEntity>("USP_FieldSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
