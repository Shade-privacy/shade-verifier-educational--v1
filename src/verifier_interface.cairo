//! Standard Verifier Interfaces for Starknet

use array::ArrayTrait;
use array::SpanTrait;

#[starknet::interface]
pub trait IVerifier<TState> {
    /// Verify a ZK proof with given public inputs
    fn verify_proof(
        self: @TState,
        proof: Array<felt252>,
        public_inputs: Array<felt252>
    ) -> bool;
    
    /// Get verification statistics
    fn get_stats(self: @TState) -> VerifierStats;
    
    /// Check if verification key is set
    fn is_initialized(self: @TState) -> bool;
}

#[starknet::interface]
pub trait IGroth16Verifier<TState> {
    fn verify_groth16(
        self: @TState,
        proof: Groth16Proof,
        public_inputs: Array<felt252>
    ) -> bool;
    
    fn get_verification_key_hash(self: @TState) -> felt252;
}

#[starknet::interface]
pub trait IPlonkVerifier<TState> {
    /// Verify PLONK proof
    fn verify_plonk(
        self: @TState,
        proof: Array<felt252>,
        public_inputs: Array<felt252>
    ) -> bool;
}

#[derive(Drop, Copy, Serde)]
pub struct VerifierStats {
    pub total_verifications: u64,
    pub successful_verifications: u64,
    pub failed_verifications: u64,
    pub average_gas_used: u128
}

/// Proof formats for different systems
#[derive(Drop, Copy, Serde)]
pub enum ProofFormat {
    Groth16: (),
    Plonk: (),
    // Note: Actual Shades uses Noir format
    // which is not included in this educational version
}

/// Verification result with metadata
#[derive(Drop, Copy, Serde)]
pub struct VerificationResult {
    pub success: bool,
    pub gas_used: u128,
    pub timestamp: u64,
    pub proof_format: ProofFormat
}

/// Standard error types for verifiers
#[derive(Drop, Copy, Serde)]
pub enum VerifierError {
    InvalidProof: (),
    InvalidInputs: (),
    NotInitialized: (),
    VerificationKeyMismatch: (),
    GasLimitExceeded: ()
}

/// Configuration for verifier
#[derive(Drop, Serde)]
pub struct VerifierConfig {
    pub max_inputs: u32,
    pub max_proof_size: u32,
    pub gas_limit: u128,
    pub require_timestamp: bool,
    pub allowed_proof_formats: Array<ProofFormat>
}

/// Helper to create default config
pub fn default_config() -> VerifierConfig {
    VerifierConfig {
        max_inputs: 100,
        max_proof_size: 1000,
        gas_limit: 1000000,
        require_timestamp: false,
        allowed_proof_formats: ArrayTrait::new()
    }
}

/// Factory for creating verifiers
#[starknet::contract]
pub mod VerifierFactory {
    use super::IVerifier;
    
    #[storage]
    struct Storage {
        deployed_verifiers: LegacyMap<felt252, bool>,
        verifier_templates: LegacyMap<felt252, felt252>
    }
    
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        VerifierDeployed: VerifierDeployedEvent
    }
    
    #[derive(Drop, starknet::Event)]
    struct VerifierDeployedEvent {
        verifier_address: felt252,
        verifier_type: felt252
    }
    
    #[external(v0)]
    fn deploy_groth16_verifier(
        self: @ContractState,
        verification_key_hash: felt252
    ) -> felt252 {
        // Educational: In reality would deploy actual contract
        // For education, return a mock address
        
        let mock_address = 0x123456789;
        
        self.deployed_verifiers.write(mock_address, true);
        
        self.emit(Event::VerifierDeployed(VerifierDeployedEvent {
            verifier_address: mock_address,
            verifier_type: 'groth16'
        }));
        
        mock_address
    }
}

/// Adapter pattern for different proof formats
pub fn adapt_proof_format(
    proof: Array<felt252>,
    from_format: ProofFormat,
    to_format: ProofFormat
) -> Array<felt252> {
    // Educational: Show how proof formats might be converted
    // In reality, this would require actual cryptographic operations
    
    let mut adapted = ArrayTrait::new();
    
    match from_format {
        ProofFormat::Groth16(()) => {
            // Simple adaptation for education
            adapted.append('Adapted from Groth16');
            adapted.append('To target format');
        },
        ProofFormat::Plonk(()) => {
            adapted.append('Adapted from PLONK');
            adapted.append('To target format');
        }
    }
    
    adapted
}




//use Garaga Tooling for onchain deployed verifiers