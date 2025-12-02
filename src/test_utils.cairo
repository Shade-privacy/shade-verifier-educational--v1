//! Not for production use

use array::ArrayTrait;

pub fn create_mock_groth16_proof() -> Groth16Proof {
    Groth16Proof {
        a: G1Point {
            x: 1,
            y: 2
        },
        b: G2Point {
            x0: 3,
            x1: 4,
            y0: 5,
            y1: 6
        },
        c: G1Point {
            x: 7,
            y: 8
        }
    }
}

pub fn create_mock_public_inputs() -> Array<felt252> {
    let mut inputs = ArrayTrait::new();
    
    // Typical public inputs for a privacy pool withdrawal
    inputs.append(123456);  // Nullifier hash
    inputs.append(789012);  // Merkle root
    inputs.append(345678);  // Recipient (obfuscated)
    
    inputs
}

/// Create a "valid" test proof (for educational tests)
pub fn create_valid_test_proof() -> Groth16Proof {
    // Create a proof that will pass our educational verification
    Groth16Proof {
        a: G1Point {
            x: 1001,
            y: 2002
        },
        b: G2Point {
            x0: 3003,
            x1: 4004,
            y0: 5005,
            y1: 6006
        },
        c: G1Point {
            x: 7007,
            y: 8008
        }
    }
}

/// Create an "invalid" test proof (for educational tests)
pub fn create_invalid_test_proof() -> Groth16Proof {
    // Create a proof that will fail our educational verification
    Groth16Proof {
        a: G1Point {
            x: 0,  // Invalid: zero point
            y: 1
        },
        b: G2Point {
            x0: 2,
            x1: 3,
            y0: 4,
            y1: 5
        },
        c: G1Point {
            x: 6,
            y: 7
        }
    }
}

/// Assert verification succeeds
pub fn assert_verification_success(
    verifier: IEducationalGroth16VerifierDispatcher,
    proof: Groth16Proof,
    inputs: Array<felt252>
) -> bool {
    let result = verifier.verify_proof(proof, inputs);
    assert(result == true, "Verification should succeed");
    true
}

/// Assert verification fails
pub fn assert_verification_failure(
    verifier: IEducationalGroth16VerifierDispatcher,
    proof: Groth16Proof,
    inputs: Array<felt252>
) -> bool {
    let result = verifier.verify_proof(proof, inputs);
    assert(result == false, "Verification should fail");
    true
}

/// Test suite runner
pub fn run_educational_tests() -> Array<felt252> {
    let mut results = ArrayTrait::new();
    
    results.append('Running educational verifier tests...');
    
    // Test 1: Valid proof structure
    let proof = create_valid_test_proof();
    let valid_structure = validate_proof_structure(proof);
    if valid_structure {
        results.append('✓ Test 1 passed: Valid proof structure');
    } else {
        results.append('✗ Test 1 failed: Valid proof structure');
    }
    
    // Test 2: Invalid proof structure
    let invalid_proof = create_invalid_test_proof();
    let invalid_structure = validate_proof_structure(invalid_proof);
    if !invalid_structure {
        results.append('✓ Test 2 passed: Invalid proof detected');
    } else {
        results.append('✗ Test 2 failed: Invalid proof not detected');
    }
    
    // Test 3: Public inputs validation
    let inputs = create_mock_public_inputs();
    let inputs_valid = validate_public_inputs(inputs);
    if inputs_valid {
        results.append('✓ Test 3 passed: Public inputs validation');
    } else {
        results.append('✗ Test 3 failed: Public inputs validation');
    }
    
    results.append('Educational tests completed');
    
    results
}

/// Helper validation function (mirrors internal implementation)
fn validate_proof_structure(proof: Groth16Proof) -> bool {
    let a_valid = proof.a.x != 0 && proof.a.y != 0;
    let b_valid = proof.b.x0 != 0 && proof.b.x1 != 0 && 
                 proof.b.y0 != 0 && proof.b.y1 != 0;
    let c_valid = proof.c.x != 0 && proof.c.y != 0;
    
    a_valid && b_valid && c_valid
}

/// Helper validation function
fn validate_public_inputs(inputs: Array<felt252>) -> bool {
    let mut i = 0;
    while i < inputs.len() {
        if *inputs[i] == 0 {
            return false;
        }
        i += 1;
    }
    inputs.len() <= 100
}

/// Performance test utility
pub fn benchmark_verification(
    verifier: IEducationalGroth16VerifierDispatcher,
    iterations: u32
) -> u128 {
    let proof = create_valid_test_proof();
    let inputs = create_mock_public_inputs();
    
    let start_gas = get_remaining_gas();  // Educational - not real gas
    
    let mut i = 0;
    while i < iterations {
        verifier.verify_proof(proof, inputs);
        i += 1;
    }
    
    let end_gas = get_remaining_gas();  // Educational - not real gas
    start_gas - end_gas  // "Gas used"
}

/// Mock gas function for education
fn get_remaining_gas() -> u128 {
    1000000  // Mock value
}

/// Generate test report
pub fn generate_test_report() -> Array<felt252> {
    let mut report = ArrayTrait::new();
    
    report.append('================================');
    report.append('Educational Verifier Test Report');
    report.append('================================');
    report.append('');
    report.append('⚠️  IMPORTANT: This is for learning only');
    report.append('Real Shades verifier has:');
    report.append('1. Actual elliptic curve operations');
    report.append('2. Noir proof verification');
    report.append('3. Production optimizations');
    report.append('4. Security audits');
    report.append('');
    report.append('Learn more at: docs.shades.org');
    
    report
}