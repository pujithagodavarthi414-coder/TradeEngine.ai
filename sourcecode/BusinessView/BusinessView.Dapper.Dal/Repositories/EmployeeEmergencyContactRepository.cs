using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeEmergencyContactRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeEmergencyContact table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeEmergencyContactDbEntity aEmployeeEmergencyContact)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeEmergencyContact.Id);
					 vParams.Add("@EmployeeId",aEmployeeEmergencyContact.EmployeeId);
					 vParams.Add("@RelationshipId",aEmployeeEmergencyContact.RelationshipId);
					 vParams.Add("@Name",aEmployeeEmergencyContact.Name);
					 vParams.Add("@SpecifiedRelation",aEmployeeEmergencyContact.SpecifiedRelation);
					 vParams.Add("@DateOfBirth",aEmployeeEmergencyContact.DateOfBirth);
					 vParams.Add("@HomeTelephone",aEmployeeEmergencyContact.HomeTelephone);
					 vParams.Add("@MobileNo",aEmployeeEmergencyContact.MobileNo);
					 vParams.Add("@WorkTelephone",aEmployeeEmergencyContact.WorkTelephone);
					 vParams.Add("@IsEmergencyContact",aEmployeeEmergencyContact.IsEmergencyContact);
					 vParams.Add("@IsDependentContact",aEmployeeEmergencyContact.IsDependentContact);
					 vParams.Add("@CreatedDateTime",aEmployeeEmergencyContact.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeEmergencyContact.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeEmergencyContact.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeEmergencyContact.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeEmergencyContactInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeEmergencyContact table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeEmergencyContactDbEntity aEmployeeEmergencyContact)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeEmergencyContact.Id);
					 vParams.Add("@EmployeeId",aEmployeeEmergencyContact.EmployeeId);
					 vParams.Add("@RelationshipId",aEmployeeEmergencyContact.RelationshipId);
					 vParams.Add("@Name",aEmployeeEmergencyContact.Name);
					 vParams.Add("@SpecifiedRelation",aEmployeeEmergencyContact.SpecifiedRelation);
					 vParams.Add("@DateOfBirth",aEmployeeEmergencyContact.DateOfBirth);
					 vParams.Add("@HomeTelephone",aEmployeeEmergencyContact.HomeTelephone);
					 vParams.Add("@MobileNo",aEmployeeEmergencyContact.MobileNo);
					 vParams.Add("@WorkTelephone",aEmployeeEmergencyContact.WorkTelephone);
					 vParams.Add("@IsEmergencyContact",aEmployeeEmergencyContact.IsEmergencyContact);
					 vParams.Add("@IsDependentContact",aEmployeeEmergencyContact.IsDependentContact);
					 vParams.Add("@CreatedDateTime",aEmployeeEmergencyContact.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeEmergencyContact.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeEmergencyContact.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeEmergencyContact.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeEmergencyContactUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeEmergencyContact table.
		/// </summary>
		public EmployeeEmergencyContactDbEntity GetEmployeeEmergencyContact(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeEmergencyContactDbEntity>("USP_EmployeeEmergencyContactSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeEmergencyContact table.
		/// </summary>
		 public IEnumerable<EmployeeEmergencyContactDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeEmergencyContactDbEntity>("USP_EmployeeEmergencyContactSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeEmergencyContact table by a foreign key.
		/// </summary>
		public List<EmployeeEmergencyContactDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeEmergencyContactDbEntity>("USP_EmployeeEmergencyContactSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
