//! This demonstrates basic verification workflow

use educational_verifier::{
    EducationalGroth16Verifier, 
    IEducationalGroth16VerifierDispatcher,
    Groth16Proof, G1Point, G2Point
};
use array::ArrayTrait;

#[starknet::contract]
mod ExampleVerifierUsage {
    use super::EducationalGroth16Verifier;
    use super::IEducationalGroth16VerifierDispatcher;
    
    #[storage]
    struct Storage {
        verifier_address: felt252,
        last_verification_result: bool
    }
    
    #[constructor]
    fn constructor(ref self: ContractState, verifier_address: felt252) {
        self.verifier_address.write(verifier_address);
    }
    
    #[external(v0)]
    fn example_verification_workflow(
        self: @ContractState
    ) -> Array<felt252> {
        let mut results = ArrayTrait::new();
        
        results.append('Starting educational verification example...');
        
        // 1. Create verifier interface
        let verifier = IEducationalGroth16VerifierDispatcher {
            contract_address: self.verifier_address.read()
        };
        
        // 2. Create a sample proof (for education)
        let proof = Groth16Proof {
            a: G1Point { x: 100, y: 200 },
            b: G2Point { x0: 300, x1: 400, y0: 500, y1: 600 },
            c: G1Point { x: 700, y: 800 }
        };
        
        // 3. Create public inputs
        let mut public_inputs = ArrayTrait::new();
        public_inputs.append(123);  // Example: nullifier hash
        public_inputs.append(456);  // Example: merkle root
        public_inputs.append(789);  // Example: recipient
        
        // 4. Verify the proof
        results.append('Verifying proof...');
        let verification_result = verifier.verify_proof(proof, public_inputs);
        
        // 5. Store result
        self.last_verification_result.write(verification_result);
        
        // 6. Get verification count
        let count = verifier.get_verification_count();
        
        // 7. Return results
        if verification_result {
            results.append('✓ Proof verification SUCCESSFUL');
        } else {
            results.append('✗ Proof verification FAILED');
        }
        
        results.append('Total verifications performed:');
        results.append(count);
        
        results.append('');
        results.append('Educational Note:');
        results.append('This example uses simplified verification.');
        results.append('Real Shades verification includes:');
        results.append('- Actual elliptic curve pairings');
        results.append('- Noir proof verification');
        results.append('- Gas optimizations');
        results.append('- Production security measures');
        
        results
    }
    
    #[external(v0)]
    fn verify_custom_proof(
        self: @ContractState,
        a_x: felt252,
        a_y: felt252,
        b_x0: felt252,
        b_x1: felt252,
        b_y0: felt252,
        b_y1: felt252,
        c_x: felt252,
        c_y: felt252,
        input1: felt252,
        input2: felt252
    ) -> bool {
        let verifier = IEducationalGroth16VerifierDispatcher {
            contract_address: self.verifier_address.read()
        };
        
        // Construct proof from parameters
        let proof = Groth16Proof {
            a: G1Point { x: a_x, y: a_y },
            b: G2Point { 
                x0: b_x0, 
                x1: b_x1, 
                y0: b_y0, 
                y1: b_y1 
            },
            c: G1Point { x: c_x, y: c_y }
        };
        
        // Create public inputs array
        let mut public_inputs = ArrayTrait::new();
        public_inputs.append(input1);
        public_inputs.append(input2);
        
        // Verify
        let result = verifier.verify_proof(proof, public_inputs);
        
        // Log result
        self.emit(Event::VerificationPerformed(VerificationPerformed {
            success: result,
            timestamp: get_block_timestamp()
        }));
        
        result
    }
    
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        VerificationPerformed: VerificationPerformed
    }
    
    #[derive(Drop, starknet::Event)]
    struct VerificationPerformed {
        success: bool,
        timestamp: u64
    }
}

/// Helper function for standalone example
pub fn run_standalone_example() -> Array<felt252> {
    let mut output = ArrayTrait::new();
    
    output.append('==================================');
    output.append('Educational Verifier Example');
    output.append('==================================');
    output.append('');
    output.append('This example shows:');
    output.append('1. How to create a Groth16 proof structure');
    output.append('2. How to prepare public inputs');
    output.append('3. How to call the verifier contract');
    output.append('4. How to handle verification results');
    output.append('');
    output.append('⚠️  REMEMBER: This is for learning only!');
    output.append('The actual Shades verifier is more complex:');
    output.append('');
    output.append('Real implementation includes:');
    output.append('- CompletePrivateFlow() verification');
    output.append('- Encrypted note validation');
    output.append('- Multi-chain state proofs');
    output.append('- Production-grade security');
    output.append('');
    output.append('Learn more: https://docs.shades.org/verification');
    
    output
}

#[test]
fn test_example_verification() {
  
    let result = run_standalone_example();
    assert(result.len() > 0, "Example should produce output");
}