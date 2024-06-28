import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClaimWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            gradient: LinearGradient(
              colors: [Color(0xFFF2F4FF), Color(0xFFEFF5FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          width: 300,
          height: 100,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFFE0DFF9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: SvgPicture.string(
                    '''
                    <svg width="25" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M0.5 1C0.5 0.447716 0.947715 0 1.5 0H23.5C24.0523 0 24.5 0.447715 24.5 1V23C24.5 23.5523 24.0523 24 23.5 24H1.5C0.947716 24 0.5 23.5523 0.5 23V1Z" fill="#F9FAFB"/>
                    <path d="M0.5 0H24.5H0.5ZM24.5 24H0.5H24.5ZM0.5 24V0V24ZM23.5 0C24.3284 0 25 0.671573 25 1.5V22.5C25 23.3284 24.3284 24 23.5 24C23.7761 24 24 23.5523 24 23V1C24 0.447715 23.7761 0 23.5 0Z" fill="#D0D5DD"/>
                    <path d="M7.83325 12H17.1666" stroke="#667085" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    ''',
                    width: 25,
                    height: 24,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '100 + Claims Filed',
                      style: TextStyle(
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      'File an OPD Claim',
                      style: TextStyle(
                        color: Color(0xFF1D2939),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'File your OPD Claim quickly and effortlessly, and let us take care of the rest',
                      style: TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF667085),
              ),
            ],
          ),
        ),
      ),
    );
  }
}