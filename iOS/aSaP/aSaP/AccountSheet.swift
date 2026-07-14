//
//  AccountSheet.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/14/26.
//

import SwiftUI

struct AccountSheet: View {
    @Binding var isPresented: Bool

    private let charcoal = Color("CharcoalBlack")
    private let asaBlue = Color("BlueGradient")
    private let logoutRed = Color("TrendTextRed")

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 0) {
                header
                profileCard
                accountActions
                logoutButton
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)
        }
        .padding(0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.white)
        .ignoresSafeArea(.container, edges: .bottom)

    }

    private var header: some View {
        HStack(alignment: .center) {
            Text("Account")
                .font(.boldeighteen)
                .foregroundStyle(charcoal)
                .lineLimit(1)

            Spacer()

            Button {
                isPresented = false
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(charcoal)
                    .frame(width: 30, height: 30)
                    .background {
                        Circle()
                            .fill(Color("BackgroundBlack"))
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close account sheet")
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 4)
    }

    private var profileCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [asaBlue.opacity(0.7), asaBlue],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text("JL")
                    .font(.boldfourteen)
                    .foregroundStyle(.white)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text("Jordan Lee")
                    .font(.beVietnam(.medium, size: 15))
                    .foregroundStyle(charcoal)
                    .lineLimit(1)

                Text("General Manager · ASA Demo Plant")
                    .font(.beVietnam(.regular, size: 12))
                    .foregroundStyle(.greyText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(asaBlue.opacity(0.06))
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    private var accountActions: some View {
        VStack(spacing: 0) {
            AccountSheetRow(title: "Settings", systemImage: "gearshape", accentColor: asaBlue)
            rowDivider
            AccountSheetRow(title: "Help & Support", systemImage: "questionmark.circle", accentColor: asaBlue)
            rowDivider
            AccountSheetRow(title: "About aSa", systemImage: "info.circle", accentColor: asaBlue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(charcoal.opacity(0.07), lineWidth: 1)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    private var rowDivider: some View {
        Rectangle()
            .fill(charcoal.opacity(0.07))
            .frame(height: 1)
            .padding(.horizontal, 20)
    }

    private var logoutButton: some View {
        Button {
            isPresented = false
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(logoutRed)
                    .frame(width: 18, height: 18)

                Text("Log Out")
                    .font(.beVietnam(.medium, size: 15))
                    .foregroundStyle(logoutRed)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(logoutRed.opacity(0.15), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 12)
    }
}

private struct AccountSheetRow: View {
    let title: String
    let systemImage: String
    let accentColor: Color

    private let charcoal = Color("CharcoalBlack")

    var body: some View {
        Button { } label: {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(accentColor)
                    .frame(width: 18, height: 18)

                Text(title)
                    .font(.beVietnam(.medium, size: 15))
                    .foregroundStyle(charcoal)
                    .lineLimit(1)

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(charcoal.opacity(0.3))
                    .frame(width: 16, height: 16)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AccountSheet(isPresented: .constant(true))
        .background(Color.gray.opacity(0.2))
}
