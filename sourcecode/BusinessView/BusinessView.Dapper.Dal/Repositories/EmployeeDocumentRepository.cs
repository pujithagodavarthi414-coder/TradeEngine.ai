using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeDocumentRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeDocument table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeDocumentDbEntity aEmployeeDocument)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeDocument.Id);
					 vParams.Add("@EmployeeId",aEmployeeDocument.EmployeeId);
					 vParams.Add("@FilePath",aEmployeeDocument.FilePath);
					 vParams.Add("@Comment",aEmployeeDocument.Comment);
					 vParams.Add("@FileSize",aEmployeeDocument.FileSize);
					 vParams.Add("@FileName",aEmployeeDocument.FileName);
					 vParams.Add("@CreatedDateTime",aEmployeeDocument.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeDocument.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeDocument.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeDocument.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeDocumentInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeDocument table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeDocumentDbEntity aEmployeeDocument)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeDocument.Id);
					 vParams.Add("@EmployeeId",aEmployeeDocument.EmployeeId);
					 vParams.Add("@FilePath",aEmployeeDocument.FilePath);
					 vParams.Add("@Comment",aEmployeeDocument.Comment);
					 vParams.Add("@FileSize",aEmployeeDocument.FileSize);
					 vParams.Add("@FileName",aEmployeeDocument.FileName);
					 vParams.Add("@CreatedDateTime",aEmployeeDocument.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeDocument.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeDocument.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeDocument.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeDocumentUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeDocument table.
		/// </summary>
		public EmployeeDocumentDbEntity GetEmployeeDocument(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeDocumentDbEntity>("USP_EmployeeDocumentSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeDocument table.
		/// </summary>
		 public IEnumerable<EmployeeDocumentDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeDocumentDbEntity>("USP_EmployeeDocumentSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeDocument table by a foreign key.
		/// </summary>
		public List<EmployeeDocumentDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeDocumentDbEntity>("USP_EmployeeDocumentSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
