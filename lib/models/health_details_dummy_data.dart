final dummydata = {
  'patient_info': {
    'name': 'Pranav Saihgal',
    'age': '25 Years',
    'gender': 'Male',
    'report_date': 'July 26, 2025',
  },
  'analysis_sections': {
    'very_alarming': {
      'short_tip': 'No critical parameters found.',
      'parameters': [],
    },
    'little_alarming': {
      'short_tip':
          'These values need medical consultation for proper evaluation.',
      'parameters': [
        {
          'parameter_name': 'Bilirubin, Direct',
          'observed_value': '0.32 mg/dL',
          'normal_range': '0-0.3 mg/dL',
          'reason_for_concern':
              'The observed value is slightly elevated above the biological reference limit. Increased direct bilirubin can indicate hepatobiliary disorders.',
          'possible_next_step':
              'Consult a physician for clinical correlation and further liver function tests.',
          'history': [
            {'time': 'Day 1', 'value': 0.28},
            {'time': 'Day 2', 'value': 0.30},
            {'time': 'Day 3', 'value': 0.31},
            {'time': 'Day 4', 'value': 0.32},
          ],
        },
        {
          'parameter_name': 'Mean Platelet Volume (MPV)',
          'observed_value': '13.1 fL',
          'normal_range': '7-13 fL',
          'reason_for_concern':
              'The value is at the upper limit. High MPV suggests larger platelets.',
          'possible_next_step':
              'Consult doctor for interpretation with complete blood count.',
        },
        {
          'parameter_name': 'Thyroid Stimulating Hormone (TSH)',
          'observed_value': '3.764 µIU/mL',
          'normal_range': '0.4-4.049 µIU/mL',
          'reason_for_concern':
              'Value near upper limit may indicate tendency towards subclinical hypothyroidism.',
          'possible_next_step':
              'Consider re-testing TSH with Free T4 for complete thyroid assessment.',
        },
      ],
    },
    'not_alarming': {
      'short_tip':
          'All major health indicators are within optimal ranges. Maintain healthy lifestyle.',
      'parameters': [
        {
          'parameter_name': 'HbA1C',
          'observed_value': '4.9%',
          'normal_range': '< 5.7%',
          'reason_for_assessment':
              'Optimal result indicating non-diabetic status and good glucose control.',
        },
        {
          'parameter_name': 'Total Cholesterol',
          'observed_value': '139 mg/dL',
          'normal_range': '< 200 mg/dL',
          'reason_for_assessment':
              'Within optimal range, indicating low cardiovascular risk.',
          'history': [
            {'time': 'Jan', 'value': 145},
            {'time': 'Feb', 'value': 142},
            {'time': 'Mar', 'value': 140},
            {'time': 'Apr', 'value': 139},
          ],
        },
        {
          'parameter_name': 'Creatinine',
          'observed_value': '1.0 mg/dL',
          'normal_range': '0.66-1.25 mg/dL',
          'reason_for_assessment':
              'Normal, suggesting healthy kidney function.',
        },
      ],
    },
  },
};
