import 'package:flutter/material.dart';

/// Mock data models for BizHealth360

class CompanyModel {
  final String id;
  final String name;
  final String pan;
  final String gstin;
  final String cin;
  final String businessType;
  final int healthScore;
  final String healthGrade;
  final int complianceScore;
  final String address;
  final String registeredDate;
  final String ownerName;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.pan,
    required this.gstin,
    required this.cin,
    required this.businessType,
    required this.healthScore,
    required this.healthGrade,
    required this.complianceScore,
    required this.address,
    required this.registeredDate,
    required this.ownerName,
  });
}

class ComplianceItem {
  final String id;
  final String title;
  final String category;
  final String status;
  final DateTime dueDate;
  final String description;
  final bool isVerified;
  final List<String> documents;

  const ComplianceItem({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.dueDate,
    required this.description,
    required this.isVerified,
    required this.documents,
  });
}

class LoanOffer {
  final String id;
  final String lenderName;
  final String lenderLogo;
  final double amount;
  final double interestRate;
  final int tenure;
  final String type;
  final String processingFee;
  final bool preApproved;

  const LoanOffer({
    required this.id,
    required this.lenderName,
    required this.lenderLogo,
    required this.amount,
    required this.interestRate,
    required this.tenure,
    required this.type,
    required this.processingFee,
    required this.preApproved,
  });
}

class AIInsight {
  final String id;
  final String title;
  final String content;
  final String type;
  final String priority;
  final DateTime createdAt;
  final String icon;

  const AIInsight({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.priority,
    required this.createdAt,
    required this.icon,
  });
}

class ClientCompany {
  final String id;
  final String name;
  final int healthScore;
  final String healthGrade;
  final int pendingCompliances;
  final String gstin;
  final Color statusColor;

  const ClientCompany({
    required this.id,
    required this.name,
    required this.healthScore,
    required this.healthGrade,
    required this.pendingCompliances,
    required this.gstin,
    required this.statusColor,
  });
}
